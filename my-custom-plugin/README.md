# Nature-Spots Custom Plugin

Nature-Spotsプロジェクト専用のClaude Code拡張パックです。

## 概要

このプラグインは、以下の機能を提供します：

- **非同期Subagents**: コードレビュー、ドキュメント処理を効率的に実行
- **Skills**: PDF抽出、Rails開発支援
- **Rules**: コーディングスタイル、セキュリティ基準の自動適用

## コンポーネント

### Agents (2個)

1. **general-code-reviewer**
   - 非同期コードレビュアー
   - セキュリティ、パフォーマンス、アーキテクチャを総合分析
   - `async: true` でバックグラウンド実行

2. **doc-processor**
   - PDF、Excel、Markdownの処理
   - 非同期でファイル抽出・分析

### Skills (2個)

1. **pdf-extractor**
   - PDFからテキスト・フォームデータを抽出
   - Ruby `pdf-reader` gemを使用

2. **rails-helper**
   - Rails開発を効率化
   - モデル、コントローラー、テストの生成支援
   - ベストプラクティスのガイド

### Rules (2個)

1. **coding-style.md**
   - TypeScript/Vue.js と Ruby/Rails のスタイルガイド
   - 命名規則、インデント、禁止パターン
   - 動的リロード対応

2. **security.md**
   - セキュリティ基準の定義
   - SQLインジェクション、XSS、CSRF等の防止
   - 機密情報保護、認証・認可の必須チェック

## インストール方法

### オプション1: ローカルプラグインとして追加

```bash
# プロジェクトルートから実行（将来のClaude Code機能）
claude plugin add ./my-custom-plugin
```

### オプション2: 手動で.claudeディレクトリにコピー

既に `.claude/` ディレクトリに配置されています。

## 使用方法

### Agentsの呼び出し

```bash
# 非同期コードレビュー
@general-code-reviewer Review the changes in src/components/SpotCard.vue

# ドキュメント処理
@doc-processor Extract text from docs/report.pdf
```

### Skillsの参照

Agentsは自動的にskillsを読み込みます：

- `general-code-reviewer` は `coding-standards` と `review-output-format` を使用
- `doc-processor` は `pdf-extractor` を使用

### Rulesの適用

Rulesは**自動的に**適用されます：

- **コード生成時**: `coding-style.md` と `security.md` に従ったコードを生成
- **コードレビュー時**: 違反を検出して警告

## 動作確認

### 1. Agentsのテスト

```bash
# コードレビューをテスト
@general-code-reviewer Review back/app/controllers/api/v1/spots_controller.rb
```

### 2. Rulesのテスト

悪いコードを生成させてルールが適用されるか確認：

```
User: Create a TypeScript function with bad indentation and any types
Agent: [coding-style.md に従って適切なコードを生成]
```

### 3. Skillsのテスト

```
User: What skills do you have for Rails development?
Agent: [rails-helper スキルの内容を説明]
```

## 技術仕様

- **バージョン**: 1.0.0
- **互換性**: Claude Code >= 2.0.0
- **非同期対応**: ✅ (async: true)
- **動的リロード**: ✅ (Rules)
- **Progressive Disclosure**: ✅ (Skills with meta: true)

## プロジェクト固有の設定

このプラグインは Nature-Spots プロジェクトに最適化されています：

- **言語**: Ruby (Rails), TypeScript (Nuxt.js/Vue.js)
- **フレームワーク**: Rails 7.1.5, Nuxt 3.10.3
- **データベース**: MySQL 5.7
- **認証**: JWT

## GitHub共有

このプラグインをGitHubで共有する場合：

1. リポジトリを作成: `nature-spots-claude-plugin`
2. `my-custom-plugin/` の内容をpush
3. README.mdに使用方法を記載
4. Claude Code コミュニティに共有

## ライセンス

MIT License

## 作成者

Nature-Spots Team

## 更新履歴

- **1.0.0** (2025-12-11): 初回リリース
  - 非同期Subagents追加
  - PDF抽出スキル
  - Rails開発支援スキル
  - コーディングスタイルルール
  - セキュリティルール
