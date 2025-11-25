# Code Review Agents - 使用ガイド

Nature-Spotsプロジェクト向けのコードレビューに特化したSubAgentsの設定ファイルです。

## 📋 概要

このディレクトリには、3つの専門的なコードレビューエージェントの設定が含まれています:

1. **Code Review Agent** - 包括的なコードレビュー
2. **Security Review Agent** - セキュリティに特化したレビュー
3. **Performance Review Agent** - パフォーマンスに特化したレビュー

## 🚀 セットアップ

### 1. ディレクトリ構造

```
.claude/
└── agents/
    ├── code-review-config.json  # エージェント設定ファイル
    └── README.md                # このファイル
```

### 2. 設定の確認

設定ファイルが正しいJSON形式であることを確認:

```bash
cat .claude/agents/code-review-config.json | jq '.'
```

## 🤖 エージェントの詳細

### 1. Code Review Agent (`code-review-agent`)

**目的**: 包括的なコードレビューを実施

**レビュー項目**:
- ✅ セキュリティ分析 (XSS, SQLインジェクション, JWT認証)
- ✅ パフォーマンス分析 (N+1クエリ, キャッシング)
- ✅ コードスタイル (TypeScript strict mode, Prettier, ESLint)
- ✅ テストカバレッジ (最低80%必須)
- ✅ ベストプラクティス

**使用モデル**: Claude Sonnet 4.5
**出力言語**: 日本語

**レビュー対象ファイル**:
- TypeScript/JavaScript (`.ts`, `.tsx`, `.js`, `.jsx`)
- Vue.js コンポーネント (`.vue`)
- Ruby (`.rb`)
- YAML設定 (`.yml`, `.yaml`)

### 2. Security Review Agent (`security-review-agent`)

**目的**: セキュリティ脆弱性の検出

**レビュー項目**:
- 🔒 OWASP Top 10 (2021) の全項目
- 🔒 JWT認証の実装確認
- 🔒 Google Maps API キーの管理
- 🔒 CORS/CSRF設定
- 🔒 依存関係の脆弱性スキャン
- 🔒 機密情報の環境変数管理

**使用モデル**: Claude Sonnet 4.5
**温度設定**: 0.2 (より厳格な分析)
**出力言語**: 日本語

**特徴**:
- 攻撃シナリオの提示
- 修正方法と推奨コードの提供
- 参考リンクの提示

### 3. Performance Review Agent (`performance-review-agent`)

**目的**: パフォーマンスボトルネックの特定と最適化

**レビュー項目**:

**バックエンド (Rails)**:
- ⚡ N+1クエリの検出
- ⚡ データベースインデックスの最適化
- ⚡ キャッシング戦略
- ⚡ APIレスポンスの最適化

**フロントエンド (Nuxt.js/Vue.js)**:
- ⚡ コンポーネントの遅延ローディング
- ⚡ 画像最適化 (WebP, lazy loading)
- ⚡ 仮想スクロール実装
- ⚡ バンドルサイズの最適化
- ⚡ Google Maps APIの効率的な使用

**使用モデル**: Claude Sonnet 4.5
**出力言語**: 日本語

**特徴**:
- 推定改善率の提示
- ベンチマーク提案
- 最適化コード例の提供

## 📖 使用方法

### Claude Code CLI での使用

```bash
# 包括的なコードレビュー
claude-code review --agent code-review-agent --file path/to/file.ts

# セキュリティレビュー
claude-code review --agent security-review-agent --file path/to/file.rb

# パフォーマンスレビュー
claude-code review --agent performance-review-agent --file path/to/file.vue
```

### カスタムコマンドとの統合

`.claude/commands/review.md` を作成して、簡単にレビューを実行:

```bash
# プルリクエスト全体をレビュー
/review pr <PR番号>

# 特定のファイルをセキュリティレビュー
/review security path/to/file.rb

# パフォーマンスレビュー
/review performance path/to/file.vue
```

## ⚙️ カスタマイズ

### 厳格性レベルの変更

`code-review-config.json` を編集:

```json
{
  "review_config": {
    "strictness_level": "high"  // "low", "medium", "high", "critical"
  }
}
```

### レビュー項目の有効/無効化

各エージェントの `focus_areas` セクションで制御:

```json
{
  "focus_areas": {
    "security": {
      "enabled": true,  // false で無効化
      "priority": "critical"
    }
  }
}
```

### 対象ファイルパターンの変更

`context_rules` セクションで制御:

```json
{
  "context_rules": {
    "include_patterns": [
      "**/*.ts",
      "**/*.vue"
    ],
    "exclude_patterns": [
      "node_modules/**",
      "dist/**"
    ]
  }
}
```

## 🎯 レビュー基準

### セキュリティの重要度レベル

- **Critical**: セキュリティ脆弱性、本番環境への影響大 → 即座に修正必須
- **High**: パフォーマンス問題、テストカバレッジ不足 → マージ前に修正必須
- **Medium**: コードスタイル違反 → マージ前の修正を推奨
- **Low**: 改善提案、リファクタリング候補 → 任意
- **Info**: 情報提供、肯定的なフィードバック

### テストカバレッジ要件

- **最低**: 80%
- **推奨**: 90%以上
- **必須テスト**: models, controllers/requests, services

### コードスタイル要件

**TypeScript**:
- Strict mode 有効
- 明示的な型定義必須
- Prettier (2スペースインデント)
- ESLint準拠

**Ruby**:
- RuboCop準拠
- Brakeman (セキュリティ監査)
- Bundle-audit (依存関係チェック)

## 🔧 トラブルシューティング

### JSON設定エラー

```bash
# JSON形式の検証
cat .claude/agents/code-review-config.json | jq '.'

# 整形して保存
cat .claude/agents/code-review-config.json | jq '.' > temp.json && mv temp.json .claude/agents/code-review-config.json
```

### エージェントが起動しない

1. Claude Code CLIのバージョンを確認
2. 設定ファイルのパスを確認
3. モデル名が正しいか確認 (`claude-sonnet-4-5-20250929`)

### レビュー結果が期待と異なる

1. `strictness_level` を調整
2. `focus_areas` で特定の項目を有効/無効化
3. `temperature` を調整 (0.2〜0.5の範囲)

## 📚 参考リソース

- [OWASP Top 10 (2021)](https://owasp.org/Top10/)
- [TypeScript Strict Mode](https://www.typescriptlang.org/tsconfig#strict)
- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [Vue.js Best Practices](https://vuejs.org/style-guide/)
- [Nuxt.js Performance](https://nuxt.com/docs/guide/concepts/performance)

## 🔄 バージョン履歴

### v1.0.0 (2025-11-24)
- 初回リリース
- Code Review Agent, Security Review Agent, Performance Review Agent を追加
- Nature-Spotsプロジェクト固有の設定を実装

## 📝 今後の拡張予定

- [ ] アクセシビリティレビューエージェント
- [ ] 国際化(i18n)レビューエージェント
- [ ] APIドキュメントレビューエージェント
- [ ] Git commit messageレビュー機能
- [ ] CI/CDパイプラインとの統合

## 💬 フィードバック

設定の改善提案やバグ報告は、プロジェクトのIssueトラッカーまでお願いします。
