---
description: 翻訳キーの整合性をチェックします。日本語と英語のロケールファイルを比較し、欠けているキーやハードコードされたテキストを検出します。
permissions:
  - allow: ["Bash", "Read", "Grep", "Glob", "Task"]
---

# i18n整合性チェック

翻訳キーの整合性をチェックし、多言語対応の問題を検出します。

## 引数
- `$ARGUMENTS`: チェック対象のディレクトリ（省略時は `front/` 全体）

## 実行手順

### 1. ロケールファイルの読み取り

```bash
# 日本語と英語のロケールファイルを読み取り
Read: front/locales/ja.json
Read: front/locales/en.json
```

### 2. 翻訳キーの抽出と比較

両方のロケールファイルから全てのキーを抽出し、以下をチェックしてください：

#### チェック項目
1. **日本語にあるが英語にないキー**
   - 重要度: 🔴 Critical
   - 影響: 英語環境でテキストが表示されない

2. **英語にあるが日本語にないキー**
   - 重要度: 🔴 Critical
   - 影響: 日本語環境でテキストが表示されない

3. **空文字列の値**
   - 重要度: 🟠 High
   - 影響: 未翻訳の可能性

#### 出力形式
```markdown
## 📋 翻訳キー整合性チェック結果

### 🔴 Critical Issues

#### 英語に欠けているキー（3件）
- `spot.detail.reviews_title` (ja.json:45)
  - 日本語: "レビュー一覧"
  - 英語: **未定義**
  - 修正: en.json に追加が必要

- `user.profile.bio_placeholder` (ja.json:78)
  - 日本語: "自己紹介を入力"
  - 英語: **未定義**
  - 修正: en.json に追加が必要

#### 日本語に欠けているキー（1件）
- `common.loading` (en.json:12)
  - 英語: "Loading..."
  - 日本語: **未定義**
  - 修正: ja.json に追加が必要

### 🟠 High Issues

#### 空文字列の値（2件）
- `spot.form.genre_label` (en.json:89)
  - 値: "" (空文字列)
  - 修正: 適切な英語訳を追加

### ✅ Summary
- Total keys in ja.json: 125
- Total keys in en.json: 123
- Missing in en.json: 3
- Missing in ja.json: 1
- Empty values: 2
- **Status**: ❌ Issues found
```

### 3. ハードコードされたテキストの検出

以下のパターンで、ハードコードされたUIテキストを検出してください：

#### 検索パターン

```bash
# 日本語のハードコード（Vue テンプレート内）
Grep: pattern='>[ぁ-んァ-ヶ一-龠ー]+<|>[ぁ-んァ-ヶ一-龠ー]' glob='front/**/*.vue' output_mode='content' -n=true

# ボタンやラベル内の英語ハードコード
Grep: pattern='<(v-btn|button|label|v-card-title)>[A-Z]' glob='front/**/*.vue' output_mode='content' -n=true

# テンプレートリテラル内の日本語
Grep: pattern='`[^`]*[ぁ-んァ-ヶ一-龠]' glob='front/**/*.{vue,ts}' output_mode='content' -n=true
```

#### 出力形式
```markdown
### 🟠 High Issues

#### ハードコードされたテキスト（5件）

1. **front/components/beforeLogin/LoginForm.vue:42**
   ```vue
   <v-btn>ログイン</v-btn>
   ```
   - 修正提案: `<v-btn>{{ $t('auth.login') }}</v-btn>`
   - 追加すべき翻訳キー:
     ```json
     // ja.json
     "auth": { "login": "ログイン" }

     // en.json
     "auth": { "login": "Login" }
     ```

2. **front/components/spot/SpotCard.vue:67**
   ```vue
   <v-card-title>スポット詳細</v-card-title>
   ```
   - 修正提案: `<v-card-title>{{ $t('spot.detail.title') }}</v-card-title>`

3. **front/composables/useToast.ts:15**
   ```typescript
   showToast('保存しました')
   ```
   - 修正提案: `showToast(t('common.saved'))`
   - 注意: `useI18n()` の `t()` 関数を使用する必要があります
```

### 4. 使用されていない翻訳キーの検出（オプション）

全ての翻訳キーに対して、実際にコード内で使用されているかをチェックしてください：

```bash
# 各翻訳キーがコード内で使われているか確認
# 例: 'auth.login' が使われているか
Grep: pattern="'auth\.login'|\"auth\.login\"|auth\.login" glob='front/**/*.{vue,ts}' output_mode='files_with_matches'
```

#### 出力形式
```markdown
### 🟡 Medium Issues

#### 未使用の翻訳キー（3件）
- `old_feature.title` (ja.json:105, en.json:103)
  - 使用箇所: 見つかりませんでした
  - 推奨: 使われていない場合は削除を検討

- `deprecated.message` (ja.json:112, en.json:110)
  - 使用箇所: 見つかりませんでした
  - 推奨: 削除を検討
```

### 5. 翻訳キーの命名規則チェック

翻訳キーが命名規則に従っているか確認してください：

**推奨パターン**: `{category}.{subcategory}.{specific_key}`

#### 検出すべき問題
```markdown
### 🟡 Medium Issues

#### 命名規則違反（4件）
- `text1` (ja.json:8)
  - 問題: 曖昧すぎるキー名
  - 修正提案: より具体的な名前に変更（例: `common.welcome_message`）

- `loginButton` (ja.json:23)
  - 問題: キャメルケースが使用されている
  - 修正提案: スネークケースに変更 `login_button`

- `user.profile.settings.account.security.password.change` (ja.json:145)
  - 問題: ネストが深すぎる（3階層を推奨）
  - 修正提案: `user.password.change` に短縮
```

### 6. サブエージェントの呼び出し（推奨）

より詳細なレビューが必要な場合は、i18n-reviewer エージェントを呼び出してください：

```bash
Task: subagent_type='i18n-reviewer' prompt='Check i18n consistency and hardcoded texts in front/ directory'
```

### 7. 修正用のスクリプト生成（オプション）

検出された問題を修正するためのスクリプトを生成できます：

```bash
# 欠けている翻訳キーを追加するための JSON パッチを生成
# （実際の修正はユーザーの承認後に実行）
```

## 出力の統合サマリー

全てのチェックが完了したら、以下の形式でサマリーを表示してください：

```markdown
# 🌐 i18n 整合性チェック完了

## 📊 統計情報
| 項目 | 日本語 | 英語 |
|------|--------|------|
| 翻訳キー総数 | 125 | 123 |
| ユニークキー数 | 126 | - |
| 欠けているキー | 1 | 3 |
| 空文字列の値 | 0 | 2 |

## ⚠️ 問題サマリー
| 重要度 | 件数 | カテゴリ |
|--------|------|---------|
| 🔴 Critical | 4 | 翻訳キーの欠落 |
| 🟠 High | 7 | ハードコードテキスト、空文字列 |
| 🟡 Medium | 7 | 命名規則違反、未使用キー |
| 合計 | **18** | |

## 📋 対応が必要な項目

### 最優先（Critical）
1. `spot.detail.reviews_title` を en.json に追加
2. `user.profile.bio_placeholder` を en.json に追加
3. `spot.form.genre_label` を en.json に追加
4. `common.loading` を ja.json に追加

### 次に対応（High）
1. LoginForm.vue:42 のハードコード "ログイン" を修正
2. SpotCard.vue:67 のハードコード "スポット詳細" を修正
3. （他のハードコードテキストも同様に）

## 🔧 推奨アクション

### 即座に対応
```bash
# 1. ロケールファイルを編集
code front/locales/ja.json
code front/locales/en.json

# 2. ハードコードテキストを修正
code front/components/beforeLogin/LoginForm.vue
```

### 後で対応（任意）
- 未使用の翻訳キーの削除
- 命名規則違反の修正（既存コードへの影響を考慮）

---

<sub>🤖 このレポートは [Claude Code](https://claude.com/claude-code) の /check-i18n コマンドによって自動生成されました。</sub>
```

## 注意事項

### false positive の回避
- **コメント内のテキスト**: 無視する
- **console.log のメッセージ**: 開発者向けなので許容
- **変数名やファイル名**: 対象外
- **外部ライブラリのテキスト**: 対象外

### 検出漏れを防ぐ
- `.vue` ファイルだけでなく `.ts` ファイルもチェック
- `composables/` と `stores/` ディレクトリ内のエラーメッセージも確認
- TypeScript の型定義内のリテラル文字列は対象外

### パフォーマンス
- ロケールファイルが大きい場合は、キーの抽出を効率的に行う
- 検索パターンは段階的に実行（全体をスキャンしすぎない）

## 例: 実行結果

```bash
$ /check-i18n

🔍 ロケールファイルを読み込んでいます...
✓ front/locales/ja.json (125 keys)
✓ front/locales/en.json (123 keys)

🔍 翻訳キーの整合性をチェックしています...
⚠️ 4件の不整合を検出

🔍 ハードコードされたテキストを検索しています...
⚠️ 7件のハードコードテキストを検出

🔍 命名規則をチェックしています...
⚠️ 4件の命名規則違反を検出

📋 レポートを生成中...

[詳細なレポートが表示される]
```
