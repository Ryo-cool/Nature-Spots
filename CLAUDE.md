# Nature-Spots

## 言語設定

**このプロジェクトでは、すべてのコミュニケーションを日本語で行うこと。**
技術用語は英語のままで構わないが、説明や会話は日本語で行う。

## プロジェクト概要

自然スポットの口コミサイト。位置情報付きでスポットを共有し、レビューやいいね機能でユーザー同士の交流を促進する。

## 技術スタック

| レイヤー | 技術 | バージョン |
|---------|------|-----------|
| Frontend | Nuxt.js + Vue.js + TypeScript | Nuxt 3.10.3, Vue 3.x |
| UI | Vuetify + Sass | Vuetify 3.7.16 |
| State | Pinia | 3.0.1 |
| i18n | Vue I18n | 11.1.2 |
| Backend | Rails + Ruby | Rails 7.1.5, Ruby 3.2.3 |
| Database | MySQL | 5.7 |
| Auth | JWT | jwt 2.2 |
| Infrastructure | Docker + Docker Compose | - |
| External API | Google Maps JavaScript API, Geocoding API | - |

## コマンドリファレンス

### Docker（推奨）

```bash
docker compose up              # アプリケーション全体を起動
docker compose up --build      # リビルドして起動
docker compose down            # 全サービス停止
```

### Frontend

```bash
cd front
yarn dev                       # 開発サーバー (localhost:8080)
yarn build                     # 本番ビルド
yarn lint                      # ESLint実行
yarn lint:fix                  # ESLint自動修正
yarn type-check                # TypeScript型チェック
yarn format                    # Prettier整形
yarn check                     # lint + type-check
yarn test:unit                 # Vitestユニットテスト
```

### Backend

```bash
cd back
bundle exec rails s            # Railsサーバー起動 (localhost:3000)
bundle exec rails c            # Railsコンソール
bundle exec rspec              # 全テスト実行
bundle exec rspec spec/models/user_spec.rb      # 単一ファイル
bundle exec rspec spec/models/user_spec.rb:25   # 特定行
bundle exec brakeman           # セキュリティ監査
bundle exec bundle-audit       # 依存関係セキュリティチェック
```

## プロジェクト構造

### Frontend (`front/`)

```
components/          # Vueコンポーネント
  ├── beforeLogin/   # 認証前画面
  ├── loggedIn/      # 認証後画面
  ├── spot/          # スポット関連
  ├── ui/            # 再利用可能UI
  ├── user/          # ユーザー関連
  ├── userPage/      # ユーザーページ
  └── welcome/       # ウェルカムページ
composables/         # Composition関数 (useAuth, useSecureStorage)
stores/              # Piniaストア (auth, spot, toast)
pages/               # ファイルベースルーティング
layouts/             # レイアウト
middleware/          # ルートミドルウェア
plugins/             # Nuxtプラグイン
locales/             # 多言語ファイル (ja.json, en.json)
types/               # TypeScript型定義
```

### Backend (`back/`)

```
app/
  ├── controllers/api/v1/   # APIコントローラー
  ├── models/               # ActiveRecordモデル
  ├── serializers/          # JSONシリアライザー
  ├── services/             # サービスオブジェクト
  ├── policies/             # 認可ポリシー
  └── validators/           # カスタムバリデーター
config/                     # Rails設定
db/                         # マイグレーション & seeds
spec/                       # RSpecテスト
```

## Claude Code 拡張機能スタック

このプロジェクトは、Claude Code 2.0の最新機能（非同期Subagents、モジュラーRules、プログレッシブディスクロージャー対応Skills）を活用した拡張機能スタックを実装しています。

### 📁 ディレクトリ構成

```
.claude/
├── agents/           # Subagents（非同期実行可能）
│   ├── general-code-reviewer.md    # 汎用コードレビュアー（async）
│   ├── doc-processor.md            # ドキュメント処理（async）
│   ├── security-reviewer.md        # セキュリティ専門レビュアー
│   ├── architecture-reviewer.md    # アーキテクチャレビュアー
│   └── performance-reviewer.md     # パフォーマンスレビュアー
├── skills/           # Skills（再利用可能な知識・ツール）
│   ├── pdf-extractor/              # PDF抽出スキル
│   ├── rails-helper/               # Rails開発支援
│   ├── coding-standards/           # コーディング規約
│   └── review-output-format/       # レビュー出力形式
├── rules/            # Rules（自動適用されるルール）
│   ├── coding-style.md             # コーディングスタイル（動的リロード）
│   └── security.md                 # セキュリティ基準（動的リロード）
└── commands/         # カスタムスラッシュコマンド
    ├── review-pr.md                # 包括的PRレビュー
    ├── review-quick.md             # 簡易レビュー
    └── review-security.md          # セキュリティレビュー
```

### 🤖 Subagents（エージェント）

#### 非同期対応エージェント

**general-code-reviewer** (async)
- **用途**: 差分コードの総合レビュー（セキュリティ、パフォーマンス、アーキテクチャ）
- **呼び出し方**: `@general-code-reviewer Review the changes in [file]`
- **特徴**: `async: true` でバックグラウンド実行、メインタスクをブロックしない
- **モデル**: sonnet
- **権限**: 読み取り専用（plan mode）

**doc-processor** (async)
- **用途**: PDF、Excel、Markdownの抽出・分析
- **呼び出し方**: `@doc-processor Extract text from [file.pdf]`
- **特徴**: 時間のかかる処理を非同期で実行
- **モデル**: haiku（コスト効率重視）
- **権限**: 確認モード（ask）

#### 専門レビュアー（既存）

- **security-reviewer**: セキュリティ脆弱性検出
- **architecture-reviewer**: アーキテクチャ設計レビュー
- **performance-reviewer**: パフォーマンス最適化提案

### 🧩 Skills（スキル）

**pdf-extractor**
- PDFファイルからテキスト・フォームデータを抽出
- Ruby `pdf-reader` gemを使用
- `meta: true` で内部実装を隠蔽

**rails-helper**
- Rails開発を効率化（モデル、コントローラー、テスト生成）
- ベストプラクティスのガイド
- Nature-Spots固有の規約に対応

**coding-standards**
- TypeScript/Vue.js と Ruby/Rails のコーディング規約
- 命名規則、禁止パターン、インポート順序
- レビュー時に自動参照

**review-output-format**
- レビュー結果の出力形式を統一
- 重要度レベル（Critical/High/Medium/Low）
- GitHub互換のMarkdown形式

### 📏 Rules（ルール）

#### coding-style.md（自動適用）

**適用タイミング**:
- コード生成時: ルールに従ったコードを自動生成
- コードレビュー時: 違反を検出して警告
- 動的リロード: ファイル変更時に自動再読み込み

**主な規則**:
- インデント: 2スペース（TypeScript/Ruby共通）
- 命名規則: camelCase（変数）、PascalCase（クラス/コンポーネント）
- 禁止パターン: `any`型、`console.log`、マジックナンバー
- インポート順序: Vue/Nuxt → 外部ライブラリ → 内部モジュール → 型定義

#### security.md（必須チェック）

**適用タイミング**:
- コード生成時: セキュアなコードパターンを使用
- コードレビュー時: 脆弱性を即座に警告

**主な規則**:
- 🔴 Critical: SQLインジェクション、XSS、機密情報のハードコーディング
- 🟠 High: 認可チェック欠如、CSRF、不適切なCORS
- 🟡 Medium: レート制限なし、セキュリティヘッダー欠如
- プロジェクト固有: JWT署名検証、Strong Parameters、Policyオブジェクト必須

### 🔧 スラッシュコマンド

**PR レビューコマンド**:
```bash
/review-pr       # 包括的なコードレビュー（セキュリティ+パフォーマンス+アーキテクチャ）
/review-quick    # 簡易レビュー（Critical/High のみ）
/review-security # セキュリティ専門レビュー
```

これらのコマンドは、対応するSubagentsを自動的に呼び出し、結果をGitHub互換形式で返します。

### 🎁 カスタムプラグイン

**nature-spots-custom v1.0.0**

プロジェクト固有の拡張機能をバンドルしたプラグインパッケージ:

- **場所**: `my-custom-plugin/`
- **内容**:
  - Agents: general-code-reviewer, doc-processor
  - Skills: pdf-extractor, rails-helper
  - Rules: coding-style, security
- **インストール方法**: 既に `.claude/` に配置済み
- **GitHub共有**: `my-custom-plugin/README.md` を参照

### 💡 使用例

#### 非同期コードレビュー
```
# バックグラウンドでレビュー実行
@general-code-reviewer Review all changes in the current PR

# メインタスクは継続可能
# レビュー完了時に通知を受け取る
```

#### Rulesの自動適用
```
# 以下のコード生成リクエストは自動的にルールに従う
User: Create a new TypeScript component for displaying spot cards
Agent: [coding-style.md と security.md に従ったコードを生成]
```

#### Skillsの活用
```
User: How do I create a new Rails model with proper associations?
Agent: [rails-helper スキルを参照して、ベストプラクティスに従った手順を提示]
```

### 🔄 動的リロード

**Rulesの更新**:
1. `.claude/rules/coding-style.md` または `security.md` を編集
2. 自動的に次回のコード生成/レビューから適用
3. 再起動不要

**優先順位**: プロジェクト固有Rules > ユーザー設定 > デフォルト

### 📊 安全性とパフォーマンス

- **読み取り専用モード**: Subagentsは `permissionMode: plan` で実行（変更提案のみ）
- **コンパクトモード**: `--compact` フラグで効率的な出力
- **Progressive Disclosure**: Skills は `meta: true` で詳細を隠蔽
- **最小コンテキスト**: 2-8個のコンポーネントに抑制（コンテキスト肥大化を防止）

### 🚀 拡張機能の更新

新しいAgent、Skill、Ruleを追加する場合：

1. 対応するディレクトリに `.md` ファイルを作成
2. フロントマター（`---`）でメタデータを定義
3. CLAUDE.mdに使用方法を記載（オプション）
4. 自動的に次回起動時から利用可能

## 開発ガイドライン

### 基本原則（MUST）

1. **セキュリティ最優先** - 入力検証、認可チェック、機密情報の保護
2. **型安全性** - TypeScriptの型を明示的に定義
3. **テストカバレッジ** - 最低40%（SimpleCov設定）
4. **多言語対応** - ハードコードされた文字列はi18nキーを使用

### Frontend規約

**TypeScript（MUST）**
- `noImplicitAny: true` - 暗黙のanyを禁止
- 明示的な型定義を使用

**コンポーネント（MUST）**
- Composition API（`<script setup lang="ts">`）を使用
- コンポーネント名はPascalCase（例: `UserProfile.vue`）
- 複数単語のコンポーネント名を使用

**インポート順序（SHOULD）**
```typescript
// 1. Vue/Nuxt
import { ref, computed } from 'vue'
// 2. 外部ライブラリ
import { format } from 'date-fns'
// 3. 内部モジュール
import { useAuthStore } from '~/stores/auth'
import type { User } from '~/types'
```

**State管理（MUST）**
- グローバル状態はPiniaストアを使用
- ストア外からの直接的な状態変更を禁止

**命名規則**
- 変数・関数: camelCase
- 定数: UPPER_SNAKE_CASE
- ファイル: kebab-case または PascalCase（コンポーネント）

### Backend規約

**Rails（MUST）**
- Strong Parametersを使用
- 複雑なビジネスロジックはServiceオブジェクトに分離
- APIレスポンスはSerializerを使用
- N+1クエリを回避（includes/preloadを活用）

**セキュリティ（MUST）**
- 認可はPolicyオブジェクトで実装
- Rack::Attackでレート制限
- 全ての入力を検証

**API設計（MUST）**
- RESTful設計
- 一貫したJSONレスポンス形式
- 適切なHTTPステータスコード
- APIバージョニング（`/api/v1/`）

**テスト（SHOULD）**
- Model specs: バリデーション、アソシエーション
- Request specs: APIエンドポイント
- Service specs: ビジネスロジック
- FactoryBotでテストデータを生成

### データベース（MUST）

- スキーマ変更はマイグレーションを使用
- パフォーマンスのためにインデックスを追加
- 外部キー制約を使用

## Git運用

### ブランチ戦略

- `master` - 本番用コード
- `develop` - 統合ブランチ
- `feature/*` - 機能開発
- `bugfix/*` - バグ修正
- `hotfix/*` - 緊急修正

### コミット前チェック（MUST）

**Frontendのコードを変更した場合、コミット前に以下を実行すること：**

```bash
cd front
yarn format          # Prettierでフォーマット
yarn lint:fix        # ESLint自動修正
yarn type-check      # 型チェック
```

これはCIで検証されるため、実行せずにコミットするとCIが失敗する。

### コミットメッセージ形式

```
type(scope): description

例:
feat(auth): JWTリフレッシュトークン機能を追加
fix(spot): 位置検索APIエラーを修正
docs(readme): セットアップ手順を更新
test(user): バリデーションspecを追加
refactor(api): 共通レスポンスヘルパーを抽出
```

### PRプロセス

1. `develop`からfeatureブランチを作成
2. テスト付きで機能を実装
3. 全テストがパスすることを確認
4. `develop`へPRを作成
5. コードレビュー後にマージ

## CI/CD

### Frontend CI（`.github/workflows/frontend-ci.yml`）

PRで`front/`変更時に実行:
- ESLint
- TypeScript型チェック
- Prettier形式確認
- Nuxtビルド
- バンドルサイズチェック

### Backend CI（`.github/workflows/backend-ci.yml`）

PRで`back/`変更時に実行:
- RSpec実行
- Brakeman（セキュリティ監査）
- bundler-audit（依存関係監査）
- カバレッジレポート

## 環境変数

### Frontend

`back/environments/db.env.example`を参照して設定:
- `GOOGLE_MAPS_API_KEY` - Google Maps API
- `CRYPTO_KEY` - 暗号化キー
- `GUEST_EMAIL` / `GUEST_PASSWORD` - ゲストログイン用

### Backend

`back/environments/db.env.example`を参照して設定:
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_USER` / `MYSQL_PASSWORD`
- `DB_USERNAME` / `DB_PASSWORD`

## セキュリティチェックリスト

デプロイ前に確認:

**Frontend**
- ユーザー入力のサニタイズ
- 本番環境でのHTTPS使用
- CSPヘッダーの実装

**Backend**
- Strong Parametersの使用
- レート制限の実装
- セキュリティヘッダーの追加
- 依存関係の定期更新
- 機密情報は環境変数で管理

## トラブルシューティング

| 問題 | 解決策 |
|------|--------|
| Docker Build失敗 | `docker system prune`でキャッシュクリア |
| DB接続エラー | `db.env`の設定を確認 |
| Frontend Build失敗 | `rm -rf node_modules && yarn install` |
| 型エラー | `yarn type-check`で詳細確認 |

### デバッグコマンド

```bash
# Frontend
yarn dev --debug
yarn type-check --verbose

# Backend
bundle exec rails console
bundle exec rspec --format documentation
```
