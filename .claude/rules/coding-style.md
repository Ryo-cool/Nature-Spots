# Coding Style Rules

このルールはNature-Spotsプロジェクトのコーディングスタイルを定義します。コード生成時およびレビュー時に自動的に適用されます。

## 適用タイミング

- **コード生成時**: 新規コード作成時にこれらのルールを遵守
- **コードレビュー時**: 違反を検出して警告
- **動的リロード**: このファイルを変更すると自動的に再読み込み

---

## TypeScript/Vue.js スタイル

### インデント
- **2スペース**を使用（タブ禁止）

```typescript
// ✅ 正しい
function example() {
  const x = 1
  if (x > 0) {
    console.log('positive')
  }
}

// ❌ 間違い（4スペースまたはタブ）
function example() {
    const x = 1
	if (x > 0) {
		console.log('positive')
	}
}
```

### 命名規則

| 種類 | 規則 | 例 |
|------|------|-----|
| 変数・関数 | camelCase | `userName`, `fetchUserData` |
| 定数 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| コンポーネント | PascalCase（複数単語） | `UserProfile.vue`, `SpotCard.vue` |
| Composables | `use` + PascalCase | `useAuth`, `useSpotSearch` |
| 型/インターフェース | PascalCase | `User`, `SpotResponse` |

```typescript
// ✅ 正しい
const userName = 'John'
const MAX_ATTEMPTS = 3
interface UserProfile { }
function useAuthStore() { }

// ❌ 間違い
const UserName = 'John'  // 変数はcamelCase
const max_attempts = 3   // 定数はUPPER_SNAKE_CASE
interface user_profile { }  // PascalCase
function authStore() { }  // useプレフィックス必須
```

### 禁止パターン

#### 1. `any` 型の使用禁止
```typescript
// ❌ 禁止
const data: any = response.data
function process(input: any): any { }

// ✅ 許可
const data: SpotResponse = response.data
function process(input: SpotInput): SpotOutput { }
```

#### 2. `console.log` の残存禁止
```typescript
// ❌ 禁止（本番コード）
console.log('debug:', data)

// ✅ 許可（開発環境のみ）
if (import.meta.dev) {
  console.debug('Debug info:', data)
}
```

#### 3. マジックナンバー禁止
```typescript
// ❌ 禁止
if (spots.length > 100) { }
setTimeout(() => {}, 3000)

// ✅ 許可
const MAX_SPOTS_DISPLAY = 100
const DEBOUNCE_DELAY_MS = 3000
if (spots.length > MAX_SPOTS_DISPLAY) { }
```

### Vue.js 固有ルール

#### Composition API を使用
```vue
<!-- ❌ 禁止: Options API -->
<script>
export default {
  data() { return { count: 0 } }
}
</script>

<!-- ✅ 許可: Composition API -->
<script setup lang="ts">
const count = ref(0)
</script>
```

#### 複数単語のコンポーネント名
```vue
<!-- ❌ 禁止: 単一単語 -->
<Header />
<Footer />

<!-- ✅ 許可: 複数単語 -->
<AppHeader />
<AppFooter />
```

---

## Ruby/Rails スタイル

### インデント
- **2スペース**を使用

```ruby
# ✅ 正しい
class User
  def full_name
    "#{first_name} #{last_name}"
  end
end

# ❌ 間違い（4スペース）
class User
    def full_name
        "#{first_name} #{last_name}"
    end
end
```

### 命名規則

| 種類 | 規則 | 例 |
|------|------|-----|
| クラス | PascalCase | `SpotController`, `UserService` |
| メソッド | snake_case | `find_by_location`, `create_review` |
| 変数 | snake_case | `current_user`, `spot_params` |
| 定数 | UPPER_SNAKE_CASE | `MAX_SPOTS_PER_PAGE` |

```ruby
# ✅ 正しい
class UserService
  MAX_RETRY = 3

  def fetch_user_data
    current_user = User.find(id)
  end
end

# ❌ 間違い
class userService  # PascalCase
  max_retry = 3  # UPPER_SNAKE_CASE

  def fetchUserData  # snake_case
    CurrentUser = User.find(id)  # snake_case
  end
end
```

### 禁止パターン

#### 1. N+1クエリ
```ruby
# ❌ 禁止
@spots = Spot.all
@spots.each { |s| puts s.user.name }

# ✅ 許可
@spots = Spot.includes(:user).all
```

#### 2. Strong Parameters なし
```ruby
# ❌ 禁止
User.create(params[:user])

# ✅ 許可
User.create(user_params)

private
def user_params
  params.require(:user).permit(:name, :email)
end
```

---

## インポート順序

### TypeScript/Vue.js
```typescript
// 1. Vue/Nuxt組み込み
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'

// 2. 外部ライブラリ（アルファベット順）
import { format } from 'date-fns'
import { storeToRefs } from 'pinia'

// 3. Stores
import { useAuthStore } from '~/stores/auth'

// 4. Composables
import { useSecureStorage } from '~/composables/useSecureStorage'

// 5. Utils
import { formatDate } from '~/utils/date'

// 6. 型定義（最後）
import type { User, Spot } from '~/types'
```

---

## コメントルール

### 必須コメント
- 複雑なビジネスロジック
- 非自明なアルゴリズム
- パフォーマンス最適化の理由

```typescript
/**
 * ユーザースコアを計算
 * @param userId - 対象ユーザーのID
 * @returns 計算されたスコア（0-100）
 */
function calculateUserScore(userId: string): number {
  // 30日以上のアクティビティがあるユーザーは高スコア
  // この閾値はビジネス要件で定義されている
  const ACTIVE_THRESHOLD_DAYS = 30
  // ...
}
```

### 禁止コメント
```typescript
// ❌ 禁止: コードを説明するだけ
// ユーザーを取得する
const user = getUser(id)

// ❌ 禁止: コメントアウトされたコード
// const oldFunction = () => { }

// ❌ 禁止: TODO/FIXMEの放置（必ずIssue化）
// TODO: あとで修正する
```

---

## i18n（多言語対応）

### ハードコードされた文字列禁止
```vue
<!-- ❌ 禁止 -->
<template>
  <button>ログイン</button>
</template>

<!-- ✅ 許可 -->
<template>
  <button>{{ $t('auth.login') }}</button>
</template>
```

---

## 違反時の対応

### コード生成時
- ルールに従ったコードを生成
- 違反パターンは自動的に回避

### コードレビュー時
- 🟡 Medium レベルの警告として報告
- 修正提案を提示

### ルール変更時
- このファイルを編集すると、次回のコード生成/レビューから適用
- プロジェクト固有ルール > ユーザー設定 > デフォルト の優先順位
