---
description: PRの包括的なコードレビューを実行します。セキュリティ、パフォーマンス、アーキテクチャの3観点で分析し、GitHubにレビュー結果を投稿します。
permissions:
  - allow: ["Bash", "Read", "Grep", "Glob", "Task"]
---

# PR包括的レビュー

現在のブランチのPR、または指定されたPR番号のコードレビューを実行してください。

## 引数
- `$ARGUMENTS`: PR番号（省略時は現在のブランチのPRを対象）

## 実行手順

### 1. PR情報の取得

```bash
# PR番号が指定されている場合
gh pr view $1 --json number,title,body,files,additions,deletions,baseRefName,headRefName

# PR番号が指定されていない場合（現在のブランチ）
gh pr view --json number,title,body,files,additions,deletions,baseRefName,headRefName
```

### 2. 変更差分の取得

```bash
# 変更されたファイル一覧
gh pr diff $1 --name-only

# 差分の詳細
gh pr diff $1
```

### 3. ファイル種類の分析

変更ファイルを以下のカテゴリに分類してください：

- **Frontend**: `front/**/*.ts`, `front/**/*.vue`, `front/**/*.tsx`
- **Backend**: `back/**/*.rb`
- **Config**: `*.yml`, `*.yaml`, `*.json`, `Gemfile`, `package.json`
- **Test**: `**/spec/**`, `**/test/**`, `**/*.spec.ts`, `**/*.test.ts`
- **Docs**: `*.md`, `docs/**`

### 4. サブエージェントによるレビュー実行

変更されたファイルの種類に応じて、適切なサブエージェントを呼び出してください：

1. **security-reviewer**: 全ての変更ファイルに対してセキュリティレビュー
2. **performance-reviewer**: Frontend/Backendファイルに対してパフォーマンスレビュー
3. **architecture-reviewer**: Frontend/Backendファイルに対してアーキテクチャレビュー

各サブエージェントには以下の情報を渡してください：
- 変更されたファイルのリスト
- 差分の内容
- PRの説明

### 5. レビュー結果の統合

各サブエージェントからの結果を統合し、以下の形式でまとめてください：

```markdown
# 📋 PR #[番号] レビュー結果

## PR情報
- **タイトル**: [PRタイトル]
- **ベースブランチ**: [base] ← [head]
- **変更ファイル数**: [数]
- **変更行数**: +[追加] / -[削除]

## サマリー
| 観点 | Critical | High | Medium | Low |
|------|----------|------|--------|-----|
| 🔒 セキュリティ | 0 | 0 | 0 | 0 |
| ⚡ パフォーマンス | 0 | 0 | 0 | 0 |
| 🏗️ アーキテクチャ | 0 | 0 | 0 | 0 |
| **合計** | **0** | **0** | **0** | **0** |

## 判定
[APPROVED / CHANGES_REQUESTED / COMMENT]

---

## 🔒 セキュリティレビュー結果
[security-reviewerの出力]

---

## ⚡ パフォーマンスレビュー結果
[performance-reviewerの出力]

---

## 🏗️ アーキテクチャレビュー結果
[architecture-reviewerの出力]

---

<sub>🤖 このレビューは [Claude Code](https://claude.com/claude-code) によって自動生成されました。</sub>
```

### 6. GitHubへの投稿

レビュー結果に基づいて、適切なアクションを実行してください：

**Critical または High の問題がある場合**:
```bash
gh pr review $1 --request-changes --body "[レビュー結果]"
```

**Medium 以下の問題のみの場合**:
```bash
gh pr review $1 --comment --body "[レビュー結果]"
```

**問題がない場合**:
```bash
gh pr review $1 --approve --body "[レビュー結果]"
```

## 注意事項

- 変更されていないファイルはレビュー対象外です
- テストファイルは「テストの品質」観点でレビューしてください
- レビュー結果が長すぎる場合は、Critical/High の問題のみをコメントに含め、詳細は別途コメントしてください
- 各問題には必ず該当コードへのGitHubリンクを含めてください（形式: `[ファイル名:行番号](GitHubのURL#L行番号)`）
