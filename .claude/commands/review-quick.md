---
description: 軽量な簡易PRレビューを実行します。明らかな問題（Critical/High）のみを検出し、迅速なフィードバックを提供します。
permissions:
  - allow: ["Bash", "Read", "Grep", "Glob"]
---

# 簡易レビュー（Quick Review）

現在のブランチのPR、または指定されたPR番号の簡易レビューを実行してください。

## 引数
- `$ARGUMENTS`: PR番号（省略時は現在のブランチのPRを対象）

## 目的

迅速なフィードバックを提供するため、**明らかな問題（Critical/High）のみ**を検出します。

以下の項目は**チェックしません**：
- コードスタイル（Medium以下）
- 軽微な設計問題
- 最適化の余地

## 実行手順

### 1. 変更差分の取得

```bash
# 変更されたファイル一覧
gh pr diff $1 --name-only

# 差分の詳細（最大500行）
gh pr diff $1 | head -500
```

### 2. 高速パターンマッチング

以下の危険パターンを検索してください：

#### セキュリティ（Critical）

```bash
# SQLインジェクション（Ruby）
grep -n "where.*\#{" $(gh pr diff $1 --name-only | grep "\.rb$")
grep -n "find_by_sql.*\#{" $(gh pr diff $1 --name-only | grep "\.rb$")

# XSS（Vue.js）
grep -n "v-html" $(gh pr diff $1 --name-only | grep "\.vue$")

# ハードコードされた機密情報
grep -nE "(api_key|apiKey|secret|password|token)\s*[:=]\s*['\"][^'\"]+['\"]" $(gh pr diff $1 --name-only)

# 危険な関数（Ruby）
grep -nE "(eval|system|exec|\`)" $(gh pr diff $1 --name-only | grep "\.rb$")
```

#### パフォーマンス（High）

```bash
# 明らかなN+1クエリパターン
grep -n "\.each.*\.find\|\.each.*\.where" $(gh pr diff $1 --name-only | grep "\.rb$")

# console.log の残存
grep -n "console.log" $(gh pr diff $1 --name-only | grep -E "\.(ts|tsx|js|jsx|vue)$")
```

#### コード品質（High）

```bash
# any型の使用
grep -n ": any" $(gh pr diff $1 --name-only | grep -E "\.tsx?$")

# TODO/FIXME（新規追加のみ）
gh pr diff $1 | grep "^+" | grep -E "TODO|FIXME"
```

### 3. レビュー結果の出力

以下の簡潔な形式で結果を出力してください：

```markdown
# ⚡ 簡易レビュー結果

## PR情報
- **PR番号**: #[番号]
- **変更ファイル数**: [数]

## 検出結果

### 🔴 Critical
[該当がある場合のみ]
- `ファイル名:行番号` - [問題の概要]

### 🟠 High
[該当がある場合のみ]
- `ファイル名:行番号` - [問題の概要]

## 判定
- ✅ **LGTM** - 明らかな問題は検出されませんでした
- ⚠️ **要確認** - [N]件の問題を検出しました

---

<sub>⚡ これは簡易レビューです。詳細なレビューが必要な場合は `/review-pr` を実行してください。</sub>
```

### 4. 結果に応じた対応

**問題が検出されなかった場合**:
- レビュー結果を表示して終了
- GitHubへのコメント投稿は省略（ノイズ削減）

**Critical/High の問題が検出された場合**:
```bash
gh pr comment $1 --body "[レビュー結果]"
```

## チェック項目一覧

| カテゴリ | パターン | 重要度 |
|----------|----------|--------|
| SQLインジェクション | `where.*#{` | Critical |
| XSS | `v-html` | Critical |
| ハードコード秘密 | `api_key.*=.*"` | Critical |
| eval/system使用 | `eval\|system\|exec` | Critical |
| N+1クエリ | `.each.*\.find` | High |
| console.log残存 | `console.log` | High |
| any型使用 | `: any` | High |
| TODO/FIXME追加 | `TODO\|FIXME` | High |

## 注意事項

- このコマンドは**速度重視**です
- 誤検知の可能性があります
- 詳細なレビューが必要な場合は `/review-pr` を使用してください
- テストファイル（`*_spec.rb`, `*.test.ts`）はスキップします
