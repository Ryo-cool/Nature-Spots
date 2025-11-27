---
name: coding-standards
description: Nature-Spotsプロジェクトのコーディング規約。命名規則、禁止パターン、インポート順序、コメント基準を定義します。コードレビュー時に自動参照されます。
---

# Nature-Spots コーディング規約

このスキルはNature-Spotsプロジェクトのコーディング規約を定義します。コードレビュー時にこれらの基準に基づいて評価してください。

## 命名規則

### TypeScript/Vue.js（フロントエンド）

| 種類 | 規則 | 例 |
|------|------|-----|
| 変数・関数 | camelCase | `userName`, `fetchSpots` |
| 定数 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| コンポーネント | PascalCase（複数単語必須） | `SpotCard.vue`, `UserProfile.vue` |
| composables | useXxx形式 | `useAuth`, `useSpotSearch` |
| 型/インターフェース | PascalCase | `User`, `SpotResponse` |
| ファイル名 | kebab-case または PascalCase | `spot-card.ts`, `SpotCard.vue` |

### Ruby/Rails（バックエンド）

| 種類 | 規則 | 例 |
|------|------|-----|
| クラス | PascalCase | `SpotController`, `UserService` |
| メソッド | snake_case | `find_by_location`, `create_review` |
| 変数 | snake_case | `current_user`, `spot_params` |
| 定数 | UPPER_SNAKE_CASE | `MAX_SPOTS_PER_PAGE` |
| ファイル名 | snake_case | `spots_controller.rb`, `user_service.rb` |

## 禁止パターン

### TypeScript

```typescript
// ❌ 禁止: any型の使用
const data: any = response.data
function process(input: any): any { }

// ✅ 許可: 明示的な型定義
const data: SpotResponse = response.data
function process(input: SpotInput): SpotOutput { }
```

```typescript
// ❌ 禁止: console.log の残存（デバッグコード）
console.log('debug:', data)

// ✅ 許可: 適切なロギング（開発環境のみ）
if (import.meta.dev) {
  console.debug('Debug info:', data)
}
```

```typescript
// ❌ 禁止: マジックナンバー
if (spots.length > 100) { }
setTimeout(() => {}, 3000)

// ✅ 許可: 名前付き定数
const MAX_SPOTS_DISPLAY = 100
const DEBOUNCE_DELAY_MS = 3000
if (spots.length > MAX_SPOTS_DISPLAY) { }
```

```typescript
// ❌ 禁止: 非null アサーション演算子の乱用
const user = getCurrentUser()!
const name = user!.profile!.name!

// ✅ 許可: 適切なnullチェック
const user = getCurrentUser()
if (!user?.profile?.name) return
const name = user.profile.name
```

### Vue.js

```vue
<!-- ❌ 禁止: Options APIの使用 -->
<script>
export default {
  data() { return { } }
}
</script>

<!-- ✅ 許可: Composition API -->
<script setup lang="ts">
const data = ref({})
</script>
```

```vue
<!-- ❌ 禁止: 単一単語のコンポーネント名 -->
<template>
  <Header />
  <Footer />
</template>

<!-- ✅ 許可: 複数単語のコンポーネント名 -->
<template>
  <AppHeader />
  <AppFooter />
</template>
```

### Ruby/Rails

```ruby
# ❌ 禁止: N+1クエリを引き起こすコード
@spots = Spot.all
@spots.each { |s| puts s.user.name }

# ✅ 許可: 関連データの事前ロード
@spots = Spot.includes(:user).all
```

```ruby
# ❌ 禁止: 直接的なパラメータアクセス
User.create(params[:user])

# ✅ 許可: Strong Parameters
User.create(user_params)
private def user_params
  params.require(:user).permit(:name, :email)
end
```

## インポート順序

### TypeScript/Vue.js

```typescript
// 1. Vue/Nuxt組み込み
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

// 2. 外部ライブラリ（アルファベット順）
import { format } from 'date-fns'
import { storeToRefs } from 'pinia'

// 3. 内部モジュール - stores
import { useAuthStore } from '~/stores/auth'
import { useSpotStore } from '~/stores/spot'

// 4. 内部モジュール - composables
import { useSecureStorage } from '~/composables/useSecureStorage'

// 5. 内部モジュール - utils/helpers
import { formatDate } from '~/utils/date'

// 6. 型定義（type import）
import type { User, Spot } from '~/types'
```

### Ruby/Rails

```ruby
# 1. 標準ライブラリ
require 'json'
require 'net/http'

# 2. Gemライブラリ
require 'jwt'

# 3. Railsコンポーネント
# (通常は自動ロード)

# 4. アプリケーションコード
# (通常は自動ロード)
```

## コメント・ドキュメンテーション基準

### 必須コメント

```typescript
/**
 * 複雑なビジネスロジックには必ず説明を追加
 * @param userId - 対象ユーザーのID
 * @returns 計算されたスコア（0-100）
 */
function calculateUserScore(userId: string): number {
  // 「なぜ」この計算が必要かを説明
  // 30日以上のアクティビティがあるユーザーは高スコア
  // ...
}
```

### 不要なコメント（禁止）

```typescript
// ❌ 禁止: コードを説明するだけのコメント
// ユーザーを取得する
const user = getUser(id)

// ❌ 禁止: コメントアウトされたコード
// const oldFunction = () => { }

// ❌ 禁止: TODO/FIXMEの放置（必ずIssue化する）
// TODO: あとで修正する
```

### i18n（多言語対応）

```vue
<!-- ❌ 禁止: ハードコードされた文字列 -->
<template>
  <button>ログイン</button>
</template>

<!-- ✅ 許可: i18nキーの使用 -->
<template>
  <button>{{ $t('auth.login') }}</button>
</template>
```

## ファイル・ディレクトリ構成

### フロントエンド（front/）

```
components/
├── beforeLogin/    # 認証前の画面コンポーネント
├── loggedIn/       # 認証後の画面コンポーネント
├── spot/           # スポット関連
├── ui/             # 再利用可能なUIコンポーネント
├── user/           # ユーザー関連
└── welcome/        # ウェルカムページ

composables/        # Composition関数
stores/             # Piniaストア
pages/              # ファイルベースルーティング
types/              # TypeScript型定義
locales/            # 多言語ファイル
```

### バックエンド（back/）

```
app/
├── controllers/api/v1/  # APIコントローラー
├── models/              # ActiveRecordモデル
├── serializers/         # JSONシリアライザー
├── services/            # サービスオブジェクト
├── policies/            # 認可ポリシー
└── validators/          # カスタムバリデーター
```

## エラーハンドリング

### フロントエンド

```typescript
// ✅ 適切なエラーハンドリング
try {
  const response = await $fetch('/api/spots')
  return response
} catch (error) {
  if (error instanceof FetchError) {
    if (error.status === 401) {
      // 認証エラー処理
      navigateTo('/login')
    } else if (error.status === 404) {
      // Not Found処理
      throw createError({ statusCode: 404, message: 'スポットが見つかりません' })
    }
  }
  // 予期せぬエラーは再スロー
  throw error
}
```

### バックエンド

```ruby
# ✅ 適切なエラーハンドリング
class Api::V1::SpotsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  private

  def not_found
    render json: { error: 'リソースが見つかりません' }, status: :not_found
  end

  def forbidden
    render json: { error: 'アクセス権限がありません' }, status: :forbidden
  end
end
```

## テストの基準

### フロントエンド（Vitest）

```typescript
describe('SpotCard', () => {
  // ✅ 明確なテスト名
  it('renders spot name and description', () => { })
  it('emits click event when card is clicked', () => { })
  it('shows loading state while fetching data', () => { })
})
```

### バックエンド（RSpec）

```ruby
RSpec.describe Spot, type: :model do
  # ✅ コンテキストで条件を明示
  describe '#popular?' do
    context 'when reviews average is above 4.0 and count is above 10' do
      it 'returns true' do
        # ...
      end
    end
  end
end
```
