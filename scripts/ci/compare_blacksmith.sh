#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-${GITHUB_REPOSITORY:-Ryo-cool/Nature-Spots}}"
LIMIT="${LIMIT:-200}"

BACKEND_BASE_WORKFLOW="${BACKEND_BASE_WORKFLOW:-Backend CI}"
BACKEND_BLACKSMITH_WORKFLOW="${BACKEND_BLACKSMITH_WORKFLOW:-Backend CI (Blacksmith)}"
FRONTEND_BASE_WORKFLOW="${FRONTEND_BASE_WORKFLOW:-Frontend CI}"
FRONTEND_BLACKSMITH_WORKFLOW="${FRONTEND_BLACKSMITH_WORKFLOW:-Frontend CI (Blacksmith)}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: required command not found: $1" >&2
    exit 1
  fi
}

fetch_runs() {
  local workflow_name="$1"
  local output_file="$2"
  local raw_file
  local err_file

  raw_file="$(mktemp)"
  err_file="$(mktemp)"

  if ! gh run list \
    --repo "$REPO" \
    --workflow "$workflow_name" \
    --limit "$LIMIT" \
    --json headSha,startedAt,updatedAt,status,conclusion,event,url >"$raw_file" 2>"$err_file"; then
    if grep -q "could not find any workflows named" "$err_file"; then
      echo "Warning: workflow not found: $workflow_name" >&2
      echo '[]' > "$output_file"
      rm -f "$raw_file" "$err_file"
      return 0
    fi

    cat "$err_file" >&2
    rm -f "$raw_file" "$err_file"
    return 1
  fi

  jq '
      map(
        select(
          .status == "completed"
          and .conclusion == "success"
          and .event == "pull_request"
          and .startedAt != null
          and .updatedAt != null
          and .headSha != null
        )
      )
      | map(
          . + {
            durationSec: ((.updatedAt | fromdateiso8601) - (.startedAt | fromdateiso8601))
          }
        )
    ' "$raw_file" > "$output_file"

  rm -f "$raw_file" "$err_file"
}

build_pairs() {
  local label="$1"
  local base_file="$2"
  local blacksmith_file="$3"
  local output_file="$4"

  jq -n \
    --arg label "$label" \
    --slurpfile base "$base_file" \
    --slurpfile blacksmith "$blacksmith_file" '
      def latest_by_sha(items):
        reduce items[] as $row (
          {};
          .[$row.headSha] = (
            if .[$row.headSha] == null or .[$row.headSha].updatedAt < $row.updatedAt
            then $row
            else .[$row.headSha]
            end
          )
        );

      (latest_by_sha($base[0])) as $base_map |
      (latest_by_sha($blacksmith[0])) as $blacksmith_map |
      [
        ($base_map | keys[]) as $sha
        | select($blacksmith_map[$sha] != null)
        | {
            label: $label,
            date: ($blacksmith_map[$sha].updatedAt[0:10]),
            sha: $sha,
            base_sec: $base_map[$sha].durationSec,
            blacksmith_sec: $blacksmith_map[$sha].durationSec,
            delta_sec: ($blacksmith_map[$sha].durationSec - $base_map[$sha].durationSec),
            delta_pct: (
              if $base_map[$sha].durationSec == 0
              then null
              else ((($blacksmith_map[$sha].durationSec - $base_map[$sha].durationSec) / $base_map[$sha].durationSec) * 100)
              end
            ),
            base_url: $base_map[$sha].url,
            blacksmith_url: $blacksmith_map[$sha].url
          }
      ]
      | sort_by(.date, .sha)
    ' > "$output_file"
}

print_report() {
  local title="$1"
  local pairs_file="$2"

  echo ""
  echo "== $title =="

  jq -r '
    if length == 0 then
      "No matched successful pairs found."
    else
      (["date","sha","base_sec","blacksmith_sec","delta_sec","delta_pct"] | @tsv),
      (.[] | [
        .date,
        (.sha[0:12]),
        (.base_sec | tostring),
        (.blacksmith_sec | tostring),
        (.delta_sec | tostring),
        (if .delta_pct == null then "n/a" else ((.delta_pct | round | tostring) + "%") end)
      ] | @tsv)
    end
  ' "$pairs_file" | column -t -s $'\t'

  jq -r '
    def stats(values):
      if (values | length) == 0 then
        null
      else
        (values | sort) as $sorted
        | (values | length) as $count
        | {
            count: $count,
            avg: ((values | add) / $count),
            median: (
              if ($count % 2) == 1 then
                $sorted[($count / 2 | floor)]
              else
                (($sorted[($count / 2) - 1] + $sorted[($count / 2)]) / 2)
              end
            ),
            p90: $sorted[(((($count - 1) * 0.9)) | floor)],
            min: $sorted[0],
            max: $sorted[-1]
          }
      end;

    if length == 0 then
      "summary: count=0"
    else
      (stats([.[].base_sec])) as $base_stats
      | (stats([.[].blacksmith_sec])) as $blacksmith_stats
      | (stats([.[].delta_sec])) as $delta_stats
      | "summary(base): count=\($base_stats.count) avg=\($base_stats.avg|round)s median=\($base_stats.median|round)s p90=\($base_stats.p90|round)s min=\($base_stats.min|round)s max=\($base_stats.max|round)s",
        "summary(blacksmith): count=\($blacksmith_stats.count) avg=\($blacksmith_stats.avg|round)s median=\($blacksmith_stats.median|round)s p90=\($blacksmith_stats.p90|round)s min=\($blacksmith_stats.min|round)s max=\($blacksmith_stats.max|round)s",
        "summary(delta): count=\($delta_stats.count) avg=\($delta_stats.avg|round)s median=\($delta_stats.median|round)s p90=\($delta_stats.p90|round)s min=\($delta_stats.min|round)s max=\($delta_stats.max|round)s"
    end
  ' "$pairs_file"
}

main() {
  require_command gh
  require_command jq
  require_command column

  local temp_dir
  temp_dir="$(mktemp -d)"
  trap "rm -rf '$temp_dir'" EXIT

  local backend_base_json="$temp_dir/backend_base.json"
  local backend_blacksmith_json="$temp_dir/backend_blacksmith.json"
  local frontend_base_json="$temp_dir/frontend_base.json"
  local frontend_blacksmith_json="$temp_dir/frontend_blacksmith.json"
  local backend_pairs_json="$temp_dir/backend_pairs.json"
  local frontend_pairs_json="$temp_dir/frontend_pairs.json"

  fetch_runs "$BACKEND_BASE_WORKFLOW" "$backend_base_json"
  fetch_runs "$BACKEND_BLACKSMITH_WORKFLOW" "$backend_blacksmith_json"
  build_pairs "backend" "$backend_base_json" "$backend_blacksmith_json" "$backend_pairs_json"

  fetch_runs "$FRONTEND_BASE_WORKFLOW" "$frontend_base_json"
  fetch_runs "$FRONTEND_BLACKSMITH_WORKFLOW" "$frontend_blacksmith_json"
  build_pairs "frontend" "$frontend_base_json" "$frontend_blacksmith_json" "$frontend_pairs_json"

  echo "Repository: $REPO"
  echo "Limit per workflow: $LIMIT"
  print_report "Backend CI vs Backend CI (Blacksmith)" "$backend_pairs_json"
  print_report "Frontend CI vs Frontend CI (Blacksmith)" "$frontend_pairs_json"
}

main "$@"
