---
description: セキュリティ観点のみのPRレビューを実行します。SQLインジェクション、XSS、認証・認可の問題、機密情報の漏洩を検出します。
permissions:
  - allow: ["Bash", "Read", "Grep", "Glob", "Task"]
---

# セキュリティレビュー

現在のブランチのPR、または指定されたPR番号のセキュリティレビューを実行してください。

## 引数
- `$ARGUMENTS`: PR番号（省略時は現在のブランチのPRを対象）

## 実行手順

### 1. PR情報と差分の取得

```bash
# PR情報
gh pr view $1 --json number,title,files,additions,deletions

# 変更されたファイル一覧
gh pr diff $1 --name-only

# 差分の詳細
gh pr diff $1
```

### 2. security-reviewer サブエージェントの呼び出し

`security-reviewer` サブエージェントを使用して、以下の観点でレビューを実行してください：

- **インジェクション攻撃**: SQLインジェクション、XSS、コマンドインジェクション
- **認証・認可**: JWT実装、認可チェック、セッション管理
- **機密情報**: APIキー、パスワード、シークレットのハードコーディング
- **依存関係**: 脆弱なパッケージの使用

### 3. 追加のセキュリティチェック

サブエージェントのレビューに加えて、以下のコマンドを実行してください：

**Railsバックエンド**:
```bash
# Brakemanによるセキュリティスキャン（変更ファイルのみ）
cd back && bundle exec brakeman --only-files $(gh pr diff $1 --name-only | grep "^back/" | sed 's/^back\///' | tr '\n' ',' | sed 's/,$//')

# 依存関係の脆弱性チェック
cd back && bundle exec bundle-audit check --update
```

**フロントエンド**:
```bash
# npm audit（重大な脆弱性のみ）
cd front && yarn audit --level high
```

### 4. レビュー結果の出力

以下の形式で結果を出力してください：

```markdown
# 🔒 セキュリティレビュー結果

## PR情報
- **PR番号**: #[番号]
- **変更ファイル数**: [数]

## サマリー
| 重要度 | 件数 |
|--------|------|
| 🔴 Critical | 0 |
| 🟠 High | 0 |
| 🟡 Medium | 0 |
| 🟢 Low | 0 |

## 判定
[APPROVED / CHANGES_REQUESTED]

---

### 🔴 Critical
[該当がある場合のみ表示]

### 🟠 High
[該当がある場合のみ表示]

### 🟡 Medium
[該当がある場合のみ表示]

### 🟢 Low / Info
[該当がある場合のみ表示]

---

## 自動スキャン結果

### Brakeman
[Brakemanの出力結果]

### 依存関係チェック
[bundle-audit / yarn audit の結果]

---

<sub>🤖 このレビューは [Claude Code](https://claude.com/claude-code) によって自動生成されました。</sub>
```

### 5. GitHubへの投稿

```bash
# Critical または High がある場合
gh pr review $1 --request-changes --body "[レビュー結果]"

# それ以外
gh pr review $1 --comment --body "[レビュー結果]"
```

## セキュリティチェックリスト

レビュー時に以下の項目を確認してください：

### 入力処理
- [ ] ユーザー入力がサニタイズされているか
- [ ] SQLクエリでパラメータ化が使用されているか
- [ ] v-html の使用が適切か

### 認証・認可
- [ ] 認証が必要なエンドポイントに認証チェックがあるか
- [ ] 認可チェック（Policy）が実装されているか
- [ ] JWTの有効期限が適切か

### 機密情報
- [ ] APIキーやパスワードがハードコードされていないか
- [ ] 機密情報がログに出力されていないか
- [ ] エラーメッセージで機密情報が漏洩していないか

### 依存関係
- [ ] 新しい依存パッケージに既知の脆弱性がないか
- [ ] 依存パッケージのバージョンが最新か
