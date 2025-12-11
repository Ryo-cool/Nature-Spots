# Security Rules

このルールはNature-Spotsプロジェクトのセキュリティ基準を定義します。コード生成時およびレビュー時に**必ず**チェックされます。

## 適用タイミング

- **コード生成時**: セキュアなコードを生成
- **コードレビュー時**: 脆弱性を検出して即座に警告
- **動的リロード**: このファイルを変更すると自動的に再読み込み

---

## 1. 機密情報の保護

### ハードコードされたシークレット禁止

```typescript
// ❌ Critical: 機密情報のハードコーディング
const API_KEY = "sk-1234567890abcdef"
const PASSWORD = "password123"
const JWT_SECRET = "my-secret-key"

// ✅ 許可: 環境変数から取得
const API_KEY = useRuntimeConfig().public.apiKey
const JWT_SECRET = process.env.JWT_SECRET
```

```ruby
# ❌ Critical: 機密情報のハードコーディング
API_KEY = "sk-1234567890abcdef"

# ✅ 許可: 環境変数から取得
API_KEY = ENV['API_KEY']
```

### .envファイルのコミット禁止

```bash
# .gitignore に必ず含める
.env
.env.local
.env.production
back/environments/db.env
```

---

## 2. インジェクション攻撃の防止

### SQLインジェクション

```ruby
# ❌ Critical: SQLインジェクション脆弱性
User.where("name = '#{params[:name]}'")
User.find_by_sql("SELECT * FROM users WHERE id = #{params[:id]}")

# ✅ 許可: パラメータ化クエリ
User.where(name: params[:name])
User.where("name = ?", params[:name])
User.where("name = :name", name: params[:name])
```

### XSS（クロスサイトスクリプティング）

```vue
<!-- ❌ Critical: XSS脆弱性 -->
<div v-html="userInput"></div>
<div v-html="comment.body"></div>

<!-- ✅ 許可: テキストとしてレンダリング -->
<div>{{ userInput }}</div>
<div>{{ comment.body }}</div>

<!-- ✅ 許可: サニタイズ後のHTML（明示的に必要な場合のみ） -->
<div v-html="sanitizeHtml(userInput)"></div>
```

```typescript
// サニタイズ関数の例
import DOMPurify from 'dompurify'

function sanitizeHtml(html: string): string {
  return DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br'],
    ALLOWED_ATTR: []
  })
}
```

### コマンドインジェクション

```ruby
# ❌ Critical: コマンドインジェクション
system("ls #{params[:directory]}")
`git log #{params[:branch]}`
exec("rm -rf #{params[:path]}")

# ✅ 許可: 配列形式で実行
system('ls', params[:directory])
system(['git', 'log', params[:branch]])

# ✅ より安全: Rubyの標準ライブラリを使用
require 'fileutils'
FileUtils.rm_rf(params[:path])
```

---

## 3. 認証・認可

### JWT実装の必須チェック項目

```typescript
// ✅ 必須: 署名検証
import jwt from 'jsonwebtoken'

function verifyToken(token: string): User | null {
  try {
    // 署名検証は必須
    const decoded = jwt.verify(token, JWT_SECRET)
    return decoded as User
  } catch (error) {
    return null
  }
}

// ❌ Critical: 署名検証なし
const decoded = jwt.decode(token)  // 検証スキップは禁止
```

```ruby
# ✅ 必須: 署名検証とアルゴリズム指定
decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })

# ❌ Critical: 署名検証なし
decoded = JWT.decode(token, nil, false)
```

### 認可チェックの必須化

```ruby
# ❌ High: 認可チェックなし
class Api::V1::SpotsController < ApplicationController
  def show
    @spot = Spot.find(params[:id])
    render json: @spot
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
  end
end

# ✅ 許可: Policyで認可チェック
class Api::V1::SpotsController < ApplicationController
  def show
    @spot = Spot.find(params[:id])
    authorize @spot  # 必須
    render json: @spot
  end

  def destroy
    @spot = Spot.find(params[:id])
    authorize @spot  # 必須
    @spot.destroy
  end
end
```

### パスワードポリシー

```ruby
# ✅ 必須: 適切なパスワードバリデーション
class User < ApplicationRecord
  has_secure_password

  validates :password,
    length: { minimum: 8 },
    format: {
      with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
      message: 'must include at least one lowercase letter, one uppercase letter, and one digit'
    },
    if: :password_digest_changed?
end
```

---

## 4. 入力検証

### Strong Parameters（Rails）

```ruby
# ❌ Critical: Strong Parameters なし
def create
  User.create(params[:user])  # 禁止
end

# ✅ 許可: Strong Parameters
def create
  User.create(user_params)
end

private

def user_params
  params.require(:user).permit(:name, :email, :password)
end
```

### フロントエンドでの入力検証

```typescript
// ✅ 必須: 入力検証
import { z } from 'zod'

const SpotSchema = z.object({
  name: z.string().min(1).max(50),
  description: z.string().max(500),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180)
})

function validateSpotInput(data: unknown) {
  return SpotSchema.parse(data)  // バリデーションエラーでthrow
}
```

---

## 5. CSRF保護

### Rails

```ruby
# ✅ デフォルトで有効（確認必須）
class ApplicationController < ActionController::API
  # API専用の場合はCSRF保護を無効化してJWTで保護
  # include ActionController::RequestForgeryProtection
  # protect_from_forgery with: :exception
end
```

### CORS設定

```ruby
# config/initializers/cors.rb
# ✅ 適切な設定
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['FRONTEND_URL']  # ❌ '*'は禁止
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end

# ❌ Critical: すべてのオリジンを許可
origins '*'  # 禁止
```

---

## 6. レート制限

```ruby
# config/initializers/rack_attack.rb
# ✅ 必須: レート制限の実装
class Rack::Attack
  # IP単位でのレート制限
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  # ログイン試行の制限
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/api/v1/user_token' && req.post?
      req.ip
    end
  end
end
```

---

## 7. セキュリティヘッダー

```ruby
# config/initializers/security_headers.rb
# ✅ 必須: セキュリティヘッダー設定
Rails.application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'DENY',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
}

# Content Security Policy
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.script_src  :self, :https
  policy.style_src   :self, :https, :unsafe_inline
end
```

---

## 8. ログとエラーメッセージ

### 機密情報のログ出力禁止

```ruby
# config/initializers/filter_parameter_logging.rb
# ✅ 必須: 機密情報のフィルタリング
Rails.application.config.filter_parameters += [
  :password,
  :password_confirmation,
  :token,
  :api_key,
  :secret,
  :credit_card
]
```

### エラーメッセージでの情報漏洩防止

```ruby
# ❌ High: 詳細なエラーメッセージ
rescue ActiveRecord::RecordNotFound => e
  render json: { error: e.message }, status: :not_found
end

# ✅ 許可: 一般的なエラーメッセージ
rescue ActiveRecord::RecordNotFound
  render json: { error: 'リソースが見つかりません' }, status: :not_found
end
```

---

## 9. 依存パッケージの脆弱性

### 定期的なチェック（必須）

```bash
# Backend（Ruby）
bundle exec bundle-audit check --update

# Frontend（Node.js）
yarn audit
npm audit

# または
yarn audit fix
npm audit fix
```

### CI/CDでの自動チェック

```yaml
# .github/workflows/backend-ci.yml
- name: Security Audit
  run: |
    gem install bundler-audit
    bundle exec bundle-audit check --update
```

---

## 10. HTTPS の強制

```ruby
# config/environments/production.rb
# ✅ 必須: 本番環境でHTTPSを強制
config.force_ssl = true
```

---

## 違反時の対応

| 重要度 | 条件 | 対応 |
|--------|------|------|
| **🔴 Critical** | SQLi、XSS、認証バイパス、機密情報露出 | **即座に修正必須**。デプロイ禁止 |
| **🟠 High** | 認可チェック欠如、CSRF、不適切なCORS | **修正必須**。次回デプロイまでに対応 |
| **🟡 Medium** | レート制限なし、セキュリティヘッダー欠如 | **推奨修正**。計画的に対応 |
| **🟢 Low** | ログ設定、エラーメッセージ | **ベストプラクティス**。改善推奨 |

---

## チェックリスト（コード生成/レビュー時）

- [ ] 機密情報は環境変数で管理
- [ ] ユーザー入力はすべて検証・サニタイズ
- [ ] SQLクエリはパラメータ化
- [ ] v-html の使用は最小限（サニタイズ必須）
- [ ] 認可チェック（Policy）を実装
- [ ] JWTは署名検証を実施
- [ ] Strong Parametersを使用
- [ ] レート制限を実装
- [ ] セキュリティヘッダーを設定
- [ ] 本番環境はHTTPSを強制
- [ ] 定期的な依存パッケージの監査
