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
