# 高優先度課題（High Priority）

🔴 **早急に対応すべき課題**

これらの問題は、開発効率への大きな影響や技術的負債の蓄積を防ぐために、高い優先度で対応が必要です。

---

## 📋 目次

1. [Options APIからComposition APIへの移行](#1-options-apiからcomposition-apiへの移行)
2. [$axiosから$fetchへの移行](#2-axiosからfetchへの移行)
3. [エラーハンドリングの統一](#3-エラーハンドリングの統一)
4. [テストの実装開始](#4-テストの実装開始)
5. [i18n完全実装](#5-i18n完全実装)

---

## 1. Options APIからComposition APIへの移行

### 🚨 問題の重大度
**High** - プロジェクト方針との不整合、保守性の低下

### 📍 影響範囲
**12ファイル**でOptions APIが使用されています。

#### 主要な対象ファイル

1. [front/pages/signup.vue](../../pages/signup.vue) - 全体がOptions API
2. [front/pages/spots/_id/index.vue](../../pages/spots/_id/index.vue):21-46
3. [front/pages/newspots.vue](../../pages/newspots.vue):90-173
4. [front/pages/logout.vue](../../pages/logout.vue):4-11
5. [front/pages/index.vue](../../pages/index.vue)
6. その他7ファイル

### 🔍 問題の詳細

プロジェクト指針では「**Composition API preferred over Options API**」と記載されていますが、多くのページでOptions APIが使用されています。

#### 問題例: signup.vue

```javascript
// ❌ Options API（現在の実装）
export default {
  layout: "beforeLogin",
  data() {
    return {
      isValid: false,
      loading: false,
      params: {
        user: {
          name: "",
          email: "",
          password: "",
        },
      },
    };
  },
  methods: {
    signup() {
      this.loading = true;
      setTimeout(() => {
        this.formReset();
        this.loading = false;
      }, 1500);
    },
    formReset() {
      this.params = {
        user: {
          name: "",
          email: "",
          password: "",
        },
      };
    },
  },
};
```

**問題点**:
- Nuxt 3の推奨パターンではない
- TypeScriptの型推論が弱い
- Composablesが使えない
- ツリーシェイキングが効きにくい

### ✅ 改善方法

```vue
<!-- ✅ Composition API（推奨） -->
<script setup lang="ts">
import { ref } from 'vue'

// Layout設定
definePageMeta({
  layout: 'before-login'
})

// Types
interface SignupParams {
  user: {
    name: string
    email: string
    password: string
  }
}

// State
const isValid = ref(false)
const loading = ref(false)
const params = ref<SignupParams>({
  user: {
    name: '',
    email: '',
    password: ''
  }
})

// Methods
const signup = async () => {
  loading.value = true
  try {
    // 実装...
  } finally {
    loading.value = false
  }
}

const formReset = () => {
  params.value = {
    user: {
      name: '',
      email: '',
      password: ''
    }
  }
}
</script>
```

### 🔄 移行手順

#### ステップ1: 優先度付け

| 優先度 | ファイル | 理由 |
|--------|---------|------|
| 1 | signup.vue | Critical課題でもある |
| 2 | login.vue | 認証周り |
| 3 | newspots.vue | 複雑なロジック |
| 4 | spots/_id/index.vue | よく使われるページ |
| 5 | その他 | - |

#### ステップ2: パターン別の移行方法

**パターンA: data → ref**
```javascript
// Before
data() {
  return { count: 0 }
}

// After
const count = ref(0)
```

**パターンB: computed → computed**
```javascript
// Before
computed: {
  doubleCount() {
    return this.count * 2
  }
}

// After
const doubleCount = computed(() => count.value * 2)
```

**パターンC: methods → function**
```javascript
// Before
methods: {
  increment() {
    this.count++
  }
}

// After
const increment = () => {
  count.value++
}
```

**パターンD: lifecycle → onMounted等**
```javascript
// Before
mounted() {
  console.log('mounted')
}

// After
onMounted(() => {
  console.log('mounted')
})
```

#### ステップ3: 移行チェックリスト

各ファイルの移行時にチェック:

- [ ] `<script setup lang="ts">`を使用
- [ ] `data` → `ref`または`reactive`
- [ ] `computed` → `computed()`
- [ ] `methods` → 関数
- [ ] `mounted/created` → `onMounted`等
- [ ] `this`の削除
- [ ] 型定義の追加
- [ ] Composablesの活用

### 📊 作業量の見積もり

| ファイル | 複雑度 | 期間 |
|---------|--------|------|
| signup.vue | 中 | 0.5日 |
| login.vue | 中 | 0.5日 |
| newspots.vue | 高 | 1日 |
| spots/_id/index.vue | 中 | 0.5日 |
| その他8ファイル | 低-中 | 2日 |
| **合計** | - | **4.5日** |

### 🎯 期待される効果

- ✅ Nuxt 3のベストプラクティスに準拠
- ✅ TypeScriptの型推論向上
- ✅ Composablesの活用可能
- ✅ バンドルサイズの削減
- ✅ コードの可読性向上

---

## 2. $axiosから$fetchへの移行

### 🚨 問題の重大度
**High** - 非推奨APIの使用、将来的な互換性問題

### 📍 影響範囲
**8ファイル**で`$axios`が使用されています。

#### 対象ファイル

1. [front/pages/newspots.vue](../../pages/newspots.vue):114, 121
2. [front/components/spot/spotData.vue](../../components/spot/spotData.vue)
3. [front/components/spot/reviews.vue](../../components/spot/reviews.vue)
4. その他5ファイル

### 🔍 問題の詳細

Nuxt 3では`@nuxtjs/axios`が非推奨となり、組み込みの`$fetch`や`useFetch` composableの使用が推奨されています。

```javascript
// ❌ 非推奨（Nuxt 2スタイル）
this.$axios.get("/api/v1/spots")
  .then(response => {
    this.spots = response.data
  })
  .catch(error => {
    console.error(error)
  })
```

**問題点**:
- Nuxt 3で非推奨
- SSRとの統合が不十分
- 型安全性が低い
- `this`に依存

### ✅ 改善方法

#### パターン1: useFetch composable（推奨）

```typescript
// ✅ Nuxt 3推奨（自動SSR対応）
<script setup lang="ts">
import type { Spot } from '~/types'

const { data: spots, error, pending } = await useFetch<Spot[]>(
  '/api/v1/spots',
  {
    method: 'GET',
    // 自動的にリアクティブ
    // SSR対応
    // エラーハンドリング組み込み
  }
)
</script>

<template>
  <div v-if="pending">Loading...</div>
  <div v-else-if="error">Error: {{ error.message }}</div>
  <div v-else>
    <SpotCard v-for="spot in spots" :key="spot.id" :spot="spot" />
  </div>
</template>
```

#### パターン2: $fetch（イベントハンドラー内）

```typescript
// ✅ イベント駆動の場合
const deleteSpot = async (id: number) => {
  try {
    await $fetch(`/api/v1/spots/${id}`, {
      method: 'DELETE'
    })

    toastStore.showToast({
      message: 'スポットを削除しました',
      color: 'success'
    })
  } catch (error) {
    toastStore.showToast({
      message: '削除に失敗しました',
      color: 'error'
    })
  }
}
```

#### パターン3: useAsyncData（カスタムロジック）

```typescript
// ✅ 複雑なデータ取得
const { data: spots } = await useAsyncData(
  'spots',  // キャッシュキー
  async () => {
    const response = await $fetch<ApiResponse<Spot[]>>('/api/v1/spots')
    // カスタム処理
    return response.data.filter(spot => spot.isPublic)
  },
  {
    // オプション
    server: true,  // SSRで実行
    lazy: false,   // 即座に実行
  }
)
```

### 🔄 移行パターン

#### ケース1: GET（データ取得）

```typescript
// Before
mounted() {
  this.$axios.get('/api/v1/spots')
    .then(response => {
      this.spots = response.data
    })
}

// After
const { data: spots } = await useFetch<Spot[]>('/api/v1/spots')
```

#### ケース2: POST（データ送信）

```typescript
// Before
async submit() {
  const response = await this.$axios.post('/api/v1/spots', this.params)
  this.spot = response.data
}

// After
const submit = async () => {
  const { data, error } = await useFetch('/api/v1/spots', {
    method: 'POST',
    body: params.value
  })

  if (error.value) {
    // エラーハンドリング
  } else {
    spot.value = data.value
  }
}
```

#### ケース3: DELETE

```typescript
// Before
deleteSpot(id) {
  this.$axios.delete(`/api/v1/spots/${id}`)
}

// After
const deleteSpot = async (id: number) => {
  await $fetch(`/api/v1/spots/${id}`, {
    method: 'DELETE'
  })
}
```

### 📊 移行チェックリスト

各ファイルごとに:

- [ ] `this.$axios`を検索
- [ ] GET → `useFetch`に変更
- [ ] POST/PUT/DELETE → `$fetch`に変更
- [ ] エラーハンドリング追加
- [ ] 型定義追加
- [ ] ローディング状態の管理
- [ ] テスト

### 📈 作業量の見積もり

| ファイル | API呼び出し数 | 期間 |
|---------|--------------|------|
| newspots.vue | 3箇所 | 0.5日 |
| spotData.vue | 2箇所 | 0.3日 |
| reviews.vue | 2箇所 | 0.3日 |
| その他5ファイル | 各1-2箇所 | 1日 |
| **合計** | **約15箇所** | **2.1日** |

### 🎯 期待される効果

- ✅ Nuxt 3の最新機能を活用
- ✅ SSR/SSGの自動対応
- ✅ 型安全性の向上
- ✅ エラーハンドリングの改善
- ✅ パフォーマンス向上

---

## 3. エラーハンドリングの統一

### 🚨 問題の重大度
**High** - ユーザー体験の低下、デバッグの困難

### 📍 影響範囲
プロジェクト全体で**エラーハンドリングのパターンが不統一**です。

### 🔍 問題の詳細

#### パターン1: エラーを無視してnullを返す

```typescript
// stores/auth.ts:44-47
async checkAuthState() {
  try {
    const user = await this.fetchUser()
    return user
  } catch (error) {
    this.setAuth(false)
    return null  // ← エラー情報が失われる
  }
}
```

#### パターン2: エラーをそのまま再スロー

```typescript
// stores/auth.ts:62
catch (error) {
  throw error  // ← そのまま投げるだけ
}
```

#### パターン3: consoleのみ

```typescript
// components/spot/spotData.vue:167
catch (error) {
  console.error("スポット情報の取得に失敗しました:", error)
  toastStore.showToast({
    message: "スポット情報の取得に失敗しました",
    color: "error"
  })
}
```

### ✅ 改善方法

#### ステップ1: エラー型の定義

```typescript
// types/errors.ts
export class AppError extends Error {
  constructor(
    message: string,
    public statusCode?: number,
    public code?: string,
    public details?: Record<string, any>
  ) {
    super(message)
    this.name = 'AppError'
  }
}

export class ApiError extends AppError {
  constructor(
    message: string,
    statusCode: number,
    public errors?: Record<string, string[]>
  ) {
    super(message, statusCode, 'API_ERROR')
    this.name = 'ApiError'
  }
}

export class ValidationError extends AppError {
  constructor(
    message: string,
    public field: string
  ) {
    super(message, 400, 'VALIDATION_ERROR')
    this.name = 'ValidationError'
  }
}
```

#### ステップ2: エラーハンドリング用Composable

```typescript
// composables/useErrorHandler.ts
import type { AppError } from '~/types/errors'

export function useErrorHandler() {
  const toastStore = useToastStore()
  const router = useRouter()

  const handleError = (error: unknown, context?: string) => {
    console.error(`[${context || 'Error'}]`, error)

    // エラーの種類に応じた処理
    if (error instanceof ApiError) {
      if (error.statusCode === 401) {
        // 未認証
        toastStore.showToast({
          message: 'ログインが必要です',
          color: 'warning'
        })
        router.push('/login')
      } else if (error.statusCode === 403) {
        // 権限なし
        toastStore.showToast({
          message: '権限がありません',
          color: 'error'
        })
      } else if (error.statusCode >= 500) {
        // サーバーエラー
        toastStore.showToast({
          message: 'サーバーエラーが発生しました',
          color: 'error'
        })
      } else {
        toastStore.showToast({
          message: error.message,
          color: 'error'
        })
      }
    } else if (error instanceof ValidationError) {
      toastStore.showToast({
        message: error.message,
        color: 'warning'
      })
    } else if (error instanceof Error) {
      toastStore.showToast({
        message: error.message,
        color: 'error'
      })
    } else {
      toastStore.showToast({
        message: '予期しないエラーが発生しました',
        color: 'error'
      })
    }
  }

  return { handleError }
}
```

#### ステップ3: APIプラグインでの統一処理

```typescript
// plugins/api.ts
export default defineNuxtPlugin(() => {
  const apiFetch = $fetch.create({
    onResponseError({ response }) {
      const { status, _data } = response

      // APIエラーを統一形式に変換
      throw new ApiError(
        _data?.message || 'API呼び出しに失敗しました',
        status,
        _data?.errors
      )
    }
  })

  return {
    provide: {
      api: apiFetch
    }
  }
})
```

#### ステップ4: 使用例

```typescript
// components/spot/spotData.vue
<script setup lang="ts">
const { handleError } = useErrorHandler()
const { $api } = useNuxtApp()

const fetchSpot = async (id: number) => {
  try {
    const data = await $api<Spot>(`/api/v1/spots/${id}`)
    spot.value = data
  } catch (error) {
    handleError(error, 'fetchSpot')
  }
}
</script>
```

### 📊 実装手順

| ステップ | 内容 | 期間 |
|---------|------|------|
| 1 | エラー型定義 | 0.5日 |
| 2 | useErrorHandler作成 | 1日 |
| 3 | APIプラグイン修正 | 0.5日 |
| 4 | 既存コードの移行 | 2日 |
| **合計** | - | **4日** |

### 🎯 期待される効果

- ✅ 一貫したエラー表示
- ✅ デバッグの容易化
- ✅ ユーザー体験の向上
- ✅ エラーログの構造化

---

## 4. テストの実装開始

### 🚨 問題の重大度
**High** - 品質保証の欠如

### 📍 現状
- **テストファイル数**: 0件
- **テストカバレッジ**: 0%
- **目標**: 80%

### 🔍 問題の詳細

プロジェクト指針で「最低80%のテストカバレッジを維持」とあるにも関わらず、テストが1つも存在しません。

**リスク**:
- リグレッションバグの発生
- リファクタリングが困難
- 仕様の不明確化

### ✅ 改善方法

#### ステップ1: テスト環境のセットアップ

```bash
# Vitestとテストユーティリティのインストール
cd front
yarn add -D vitest @vue/test-utils happy-dom @vitest/ui
```

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath } from 'node:url'

export default defineConfig({
  plugins: [vue()],
  test: {
    globals: true,
    environment: 'happy-dom',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'test/',
        '*.config.ts',
      ]
    }
  },
  resolve: {
    alias: {
      '~': fileURLToPath(new URL('./', import.meta.url)),
      '@': fileURLToPath(new URL('./', import.meta.url))
    }
  }
})
```

```json
// package.jsonに追加
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage"
  }
}
```

#### ステップ2: テストの優先順位

| 優先度 | 対象 | 理由 |
|--------|------|------|
| 1 | Stores | ビジネスロジックの中心 |
| 2 | Composables | 再利用される関数 |
| 3 | Components（UI） | ユーザーインタラクション |
| 4 | Pages | 統合テスト |

#### ステップ3: Storeのテスト例

```typescript
// stores/__tests__/auth.spec.ts
import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '../auth'

describe('useAuthStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('初期状態は未認証', () => {
    const store = useAuthStore()
    expect(store.isAuthenticated).toBe(false)
    expect(store.user).toBeNull()
    expect(store.token).toBe('')
  })

  it('setAuthで認証状態を変更できる', () => {
    const store = useAuthStore()
    store.setAuth(true)
    expect(store.isAuthenticated).toBe(true)
  })

  it('setUserでユーザー情報を設定できる', () => {
    const store = useAuthStore()
    const user = {
      id: 1,
      name: 'Test User',
      email: 'test@example.com'
    }
    store.setUser(user)
    expect(store.user).toEqual(user)
  })

  it('logoutで状態がリセットされる', () => {
    const store = useAuthStore()
    store.setAuth(true)
    store.setToken('test-token')
    store.setUser({ id: 1, name: 'Test', email: 'test@example.com' })

    store.logout()

    expect(store.isAuthenticated).toBe(false)
    expect(store.user).toBeNull()
    expect(store.token).toBe('')
  })
})
```

#### ステップ4: Composableのテスト例

```typescript
// composables/__tests__/useErrorHandler.spec.ts
import { describe, it, expect, vi } from 'vitest'
import { useErrorHandler } from '../useErrorHandler'
import { ApiError } from '~/types/errors'

describe('useErrorHandler', () => {
  it('ApiErrorを適切に処理する', () => {
    const { handleError } = useErrorHandler()
    const error = new ApiError('テストエラー', 400)

    // toastStoreのモック確認
    handleError(error)

    // toastStore.showToastが呼ばれたことを確認
    // （実際にはtoastStoreをモック化する必要がある）
  })

  it('401エラーでログインページにリダイレクト', () => {
    const { handleError } = useErrorHandler()
    const error = new ApiError('未認証', 401)

    handleError(error)

    // router.pushが呼ばれたことを確認
  })
})
```

#### ステップ5: コンポーネントのテスト例

```typescript
// components/__tests__/ui/ToastNotification.spec.ts
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import ToastNotification from '../ui/ToastNotification.vue'
import { createPinia, setActivePinia } from 'pinia'

describe('ToastNotification', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('メッセージが表示される', () => {
    const wrapper = mount(ToastNotification)
    const toastStore = useToastStore()

    toastStore.showToast({
      message: 'テストメッセージ',
      color: 'success'
    })

    expect(wrapper.text()).toContain('テストメッセージ')
  })

  it('色が正しく設定される', () => {
    const wrapper = mount(ToastNotification)
    const toastStore = useToastStore()

    toastStore.showToast({
      message: 'エラー',
      color: 'error'
    })

    // v-snackbarのcolor propを確認
    expect(wrapper.findComponent({ name: 'VSnackbar' }).props('color')).toBe('error')
  })
})
```

### 📊 テスト実装計画

| 週 | 対象 | ファイル数 | カバレッジ目標 |
|----|------|-----------|--------------|
| 1 | 環境セットアップ + Store | 3ファイル | 20% |
| 2 | Composables | 5ファイル | 40% |
| 3 | UI Components | 10ファイル | 60% |
| 4 | Pages + E2E | 5ファイル | 80% |

### 🎯 期待される効果

- ✅ バグの早期発見
- ✅ リファクタリングの安全性向上
- ✅ ドキュメントとしての役割
- ✅ 開発者の自信向上

---

## 5. i18n完全実装

### 🚨 問題の重大度
**High** - 国際化要件の未達成

### 📍 現状
- i18nプラグインは設定済み
- **日本語**: ほとんどハードコード
- **英語**: 完全に未実装（`en.json`が空）

### 🔍 問題の詳細

```vue
<!-- ❌ ハードコードの例 -->
<!-- pages/login.vue:10 -->
<nuxt-link to="#" class="body-2 text-decoration-none">
  パスワードを忘れた?
</nuxt-link>

<!-- components/loggedIn/header/loggedInAppBar.vue:15 -->
お気に入りスポット
```

### ✅ 改善方法

#### ステップ1: 翻訳ファイルの整備

```json
// locales/ja.json
{
  "common": {
    "login": "ログイン",
    "logout": "ログアウト",
    "signup": "新規登録",
    "save": "保存",
    "cancel": "キャンセル",
    "delete": "削除",
    "edit": "編集",
    "loading": "読み込み中...",
    "error": "エラーが発生しました"
  },
  "auth": {
    "email": "メールアドレス",
    "password": "パスワード",
    "forgotPassword": "パスワードを忘れた?",
    "rememberMe": "ログイン状態を保持する",
    "loginSuccess": "ログインしました",
    "logoutSuccess": "ログアウトしました",
    "loginError": "ログインに失敗しました"
  },
  "spot": {
    "title": "スポット",
    "newSpot": "新しいスポット",
    "favoriteSpots": "お気に入りスポット",
    "spotName": "スポット名",
    "description": "説明",
    "location": "場所"
  },
  "validation": {
    "required": "{field}を入力してください",
    "email": "メールアドレスの形式が正しくありません",
    "minLength": "{field}は{min}文字以上で入力してください",
    "maxLength": "{field}は{max}文字以内で入力してください"
  }
}
```

```json
// locales/en.json
{
  "common": {
    "login": "Login",
    "logout": "Logout",
    "signup": "Sign Up",
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "edit": "Edit",
    "loading": "Loading...",
    "error": "An error occurred"
  },
  "auth": {
    "email": "Email",
    "password": "Password",
    "forgotPassword": "Forgot password?",
    "rememberMe": "Remember me",
    "loginSuccess": "Logged in successfully",
    "logoutSuccess": "Logged out successfully",
    "loginError": "Login failed"
  },
  "spot": {
    "title": "Spot",
    "newSpot": "New Spot",
    "favoriteSpots": "Favorite Spots",
    "spotName": "Spot Name",
    "description": "Description",
    "location": "Location"
  },
  "validation": {
    "required": "Please enter {field}",
    "email": "Invalid email format",
    "minLength": "{field} must be at least {min} characters",
    "maxLength": "{field} must be at most {max} characters"
  }
}
```

#### ステップ2: コンポーネントの修正

```vue
<!-- ✅ i18n使用 -->
<script setup lang="ts">
const { t } = useI18n()
</script>

<template>
  <!-- Before: パスワードを忘れた? -->
  <!-- After: -->
  <nuxt-link to="#" class="body-2 text-decoration-none">
    {{ t('auth.forgotPassword') }}
  </nuxt-link>

  <!-- Before: お気に入りスポット -->
  <!-- After: -->
  {{ t('spot.favoriteSpots') }}
</template>
```

#### ステップ3: バリデーションメッセージの国際化

```typescript
// composables/useValidation.ts
export function useValidation() {
  const { t } = useI18n()

  const emailRules = [
    (v: string) => !!v || t('validation.required', { field: t('auth.email') }),
    (v: string) => /.+@.+\..+/.test(v) || t('validation.email'),
  ]

  const passwordRules = [
    (v: string) => !!v || t('validation.required', { field: t('auth.password') }),
    (v: string) => v.length >= 8 || t('validation.minLength', { field: t('auth.password'), min: 8 }),
  ]

  return {
    emailRules,
    passwordRules
  }
}
```

#### ステップ4: 言語切り替えUI

```vue
<!-- components/ui/LanguageSwitcher.vue -->
<script setup lang="ts">
const { locale, locales } = useI18n()

const switchLanguage = (lang: string) => {
  locale.value = lang
  // LocalStorageに保存
  if (process.client) {
    localStorage.setItem('locale', lang)
  }
}
</script>

<template>
  <v-menu>
    <template #activator="{ props }">
      <v-btn icon v-bind="props">
        <v-icon>mdi-translate</v-icon>
      </v-btn>
    </template>
    <v-list>
      <v-list-item
        v-for="lang in locales"
        :key="lang.code"
        @click="switchLanguage(lang.code)"
      >
        <v-list-item-title>{{ lang.name }}</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-menu>
</template>
```

### 📊 実装計画

| フェーズ | 内容 | 期間 |
|---------|------|------|
| 1 | 翻訳キーの洗い出し | 1日 |
| 2 | ja.json完成 | 2日 |
| 3 | en.json完成 | 2日 |
| 4 | コンポーネント修正 | 3日 |
| 5 | 言語切り替えUI | 1日 |
| **合計** | - | **9日** |

### 🎯 期待される効果

- ✅ 英語圏ユーザーの獲得
- ✅ メンテナンス性の向上
- ✅ 一貫した文言管理
- ✅ グローバル展開の準備

---

## 📊 高優先度課題の全体スケジュール

### 推奨される実装順序

```
週1-2: Composition API移行開始
  ├─ signup.vue移行
  ├─ login.vue移行
  └─ 主要ページ移行

週3-4: $axios → $fetch移行
  ├─ useFetch導入
  └─ 全ファイル修正

週5-6: エラーハンドリング統一
  ├─ エラー型定義
  ├─ useErrorHandler作成
  └─ 既存コード移行

週7-10: テスト実装
  ├─ 環境セットアップ
  ├─ Store/Composableテスト
  ├─ Componentテスト
  └─ カバレッジ80%達成

週11-12: i18n完全実装
  ├─ 翻訳ファイル作成
  ├─ コンポーネント修正
  └─ 言語切り替えUI
```

### 🎯 完了基準

- [ ] 全ページがComposition APIに移行
- [ ] $axiosが0箇所（完全削除）
- [ ] エラーハンドリングが統一
- [ ] テストカバレッジ80%達成
- [ ] ハードコード文字列が0箇所

次は **[03-medium-priority.md](./03-medium-priority.md)** を読んで、中優先度課題を確認してください。
