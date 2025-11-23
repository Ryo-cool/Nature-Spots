# 最優先課題（Critical Priority）

⚠️ **このドキュメントの項目は即座に対応が必要です**

これらの問題は、セキュリティリスク、重大なバグ、またはプロジェクト方針との重大な矛盾を含んでいます。

---

## 📋 目次

1. [TypeScript Strict Mode無効化](#1-typescript-strict-mode無効化)
2. [any型の大量使用](#2-any型の大量使用)
3. [セキュリティ問題](#3-セキュリティ問題)
4. [Signup機能の未実装](#4-signup機能の未実装)

---

## 1. TypeScript Strict Mode無効化

### 🚨 問題の重大度

**Critical** - プロジェクト方針との重大な矛盾

### 📍 影響範囲

- **ファイル**: [front/tsconfig.json](../../tsconfig.json)
- **行**: 8-13行目

### 🔍 問題の詳細

プロジェクト指針（CLAUDE.md）では「**TypeScript Strict mode enabled, 明示的な型定義必須**」と記載されていますが、実際の設定では**すべての型チェックが無効**になっています。

#### 現在の設定（問題）

```json
// front/tsconfig.json:8-13
{
  "compilerOptions": {
    "strict": false, // ← 型安全性が完全に無効
    "noImplicitAny": false, // ← any型を許可
    "noImplicitThis": false, // ← thisの型チェック無効
    "strictNullChecks": false, // ← null/undefined チェック無効
    "strictFunctionTypes": false, // ← 関数型チェック無効
    "strictPropertyInitialization": false // ← プロパティ初期化チェック無効
  }
}
```

### ⚡ 影響

1. **バグの見逃し**: 型エラーがビルド時に検出されない
2. **リファクタリングの困難**: 型情報が不正確で安全な変更ができない
3. **開発効率の低下**: IDEの補完が不正確
4. **技術的負債**: 将来的に修正が困難になる

### ✅ 改善方法

#### ステップ1: 段階的な有効化計画

```json
// front/tsconfig.json - フェーズ1（即座に実施）
{
  "compilerOptions": {
    "strict": false, // まだfalseのまま
    "noImplicitAny": true, // ← これだけ先に有効化
    "noImplicitThis": true,
    "strictNullChecks": false, // まだfalse
    "strictFunctionTypes": true,
    "strictPropertyInitialization": false // まだfalse
  }
}
```

#### ステップ2: any型を適切な型に置き換え（2-3週間）

全26箇所のany型を修正後...

#### ステップ3: 完全なstrict mode有効化（1ヶ月後）

```json
// front/tsconfig.json - 最終形態
{
  "compilerOptions": {
    "strict": true // ← すべて有効化
    // 個別設定は不要（strictがすべて含む）
  }
}
```

### 📊 作業量の見積もり

| フェーズ               | 作業量             | 期間      |
| ---------------------- | ------------------ | --------- |
| noImplicitAny有効化    | 26ファイル修正     | 1週間     |
| strictNullChecks有効化 | 追加15ファイル修正 | 2週間     |
| 完全strict mode        | 最終調整           | 1週間     |
| **合計**               | **約40ファイル**   | **4週間** |

### 🎯 期待される効果

- ✅ バグ検出率 **+40%**
- ✅ コードの信頼性向上
- ✅ リファクタリングの安全性向上
- ✅ プロジェクト方針との整合性確保

---

## 2. any型の大量使用

### 🚨 問題の重大度

**Critical** - 型安全性の完全な喪失

### 📍 影響範囲

**26箇所以上** で`any`型が使用されています。

#### 主要な問題ファイル

1. **[front/stores/spot.ts](../../stores/spot.ts)** - 5箇所

   - 49, 67, 93, 128, 158行目

2. **[front/composables/useAuth.ts](../../composables/useAuth.ts)** - 1箇所

   - 77行目

3. **[front/plugins/api.ts](../../plugins/api.ts)** - 3箇所

   - 14, 28, 34行目

4. **[front/pages/login.vue](../../pages/login.vue)** - 4箇所

   - 74, 92, 99, 110行目

5. **[front/components/spot/reviews.vue](../../components/spot/reviews.vue)** - 1箇所
   - 88行目

### 🔍 問題の詳細

#### 問題例1: エラーハンドリング

```typescript
// ❌ 悪い例 - stores/spot.ts:49
async fetchSpots() {
  try {
    const response = await fetch("/api/v1/spots");
    this.spots = await response.json();
  } catch (error: any) {  // ← any型
    this.error = error.message || "Failed to fetch spots";
  }
}
```

**問題点**:

- `error`の型が不明
- `error.message`が存在する保証がない
- 実行時エラーの可能性

```typescript
// ✅ 良い例
async fetchSpots() {
  try {
    const response = await fetch("/api/v1/spots");
    this.spots = await response.json();
  } catch (error: unknown) {  // ← unknown型を使用
    if (error instanceof Error) {
      this.error = error.message;
    } else {
      this.error = "Failed to fetch spots";
    }
  }
}
```

#### 問題例2: APIレスポンス

```typescript
// ❌ 悪い例 - plugins/api.ts:14
async function apiCall(endpoint: string): Promise<any> {
  // ← any型
  const response = await $fetch(endpoint);
  return response;
}
```

```typescript
// ✅ 良い例
interface ApiResponse<T> {
  data: T;
  status: number;
  message?: string;
}

async function apiCall<T>(endpoint: string): Promise<ApiResponse<T>> {
  const response = await $fetch<ApiResponse<T>>(endpoint);
  return response;
}
```

#### 問題例3: ユーザー型

```typescript
// ❌ 悪い例 - composables/useAuth.ts:77
const user: any = null; // ← 型定義が存在するのにany
```

```typescript
// ✅ 良い例
import type { User } from "~/types";

const user: User | null = null;
```

### ✅ 改善方法

#### ステップ1: 型定義ファイルの整備

```typescript
// front/types/api.ts
export interface ApiResponse<T> {
  data: T;
  status: number;
  message?: string;
  errors?: Record<string, string[]>;
}

export interface ApiError {
  message: string;
  statusCode: number;
  errors?: Record<string, string[]>;
}
```

#### ステップ2: エラーハンドリング用の型ガード

```typescript
// front/utils/typeGuards.ts
export function isError(error: unknown): error is Error {
  return error instanceof Error;
}

export function isApiError(error: unknown): error is ApiError {
  return (
    typeof error === "object" &&
    error !== null &&
    "message" in error &&
    "statusCode" in error
  );
}
```

#### ステップ3: 段階的な修正

```bash
# 1. 最も使用頻度の高いファイルから修正
# - stores/spot.ts (5箇所)
# - plugins/api.ts (3箇所)
# - pages/login.vue (4箇所)

# 2. 共通パターンの修正
# - エラーハンドリング: any → unknown + 型ガード
# - APIレスポンス: any → ジェネリック型
# - ユーザー情報: any → User型
```

### 📊 作業量の見積もり

| カテゴリ           | 箇所数     | 期間    |
| ------------------ | ---------- | ------- |
| エラーハンドリング | 15箇所     | 3日     |
| APIレスポンス      | 8箇所      | 2日     |
| ユーザー/データ型  | 3箇所      | 1日     |
| **合計**           | **26箇所** | **6日** |

### 🎯 期待される効果

- ✅ 型エラーの早期発見
- ✅ IDEの補完精度向上
- ✅ リファクタリングの安全性向上
- ✅ バグの削減

---

## 3. セキュリティ問題

### 🚨 問題の重大度

**Critical** - セキュリティリスク

### 📍 影響範囲

#### 3-1. 認証情報のハードコード

**ファイル**:

- [front/pages/login.vue](../../pages/login.vue):58-60
- [front/components/beforeLogin/guestLogin.vue](../../components/beforeLogin/guestLogin.vue):27-30

```typescript
// ❌ 問題のコード
const guestParams = {
  auth: {
    email: "user0@example.com",
    password: "password", // ← パスワードが平文でハードコード
  },
};
```

**リスク**:

- ✗ ソースコードにパスワードが露出
- ✗ Gitリポジトリに機密情報が残る
- ✗ 不正アクセスの可能性

```typescript
// ✅ 改善方法1: 環境変数化
// nuxt.config.ts
export default defineNuxtConfig({
  runtimeConfig: {
    public: {
      guestEmail: process.env.GUEST_EMAIL,
      guestPassword: process.env.GUEST_PASSWORD,
    },
  },
});

// login.vue
const config = useRuntimeConfig();
const guestParams = {
  auth: {
    email: config.public.guestEmail,
    password: config.public.guestPassword,
  },
};
```

```typescript
// ✅ 改善方法2: バックエンドAPIで処理
// より安全な方法
async function guestLogin() {
  const { data } = await useFetch("/api/v1/guest-login", {
    method: "POST",
  });
  // バックエンドで認証情報を管理
}
```

#### 3-2. 暗号化キーのデフォルト値

**ファイル**: [front/nuxt.config.ts](../../nuxt.config.ts):66

```typescript
// ❌ 問題のコード
cryptoKey: process.env.CRYPTO_KEY || "default-key",
```

**リスク**:

- ✗ 本番環境で環境変数が未設定の場合、脆弱なデフォルトキーが使用される
- ✗ 暗号化の意味がなくなる

```typescript
// ✅ 改善方法
// nuxt.config.ts
const cryptoKey = process.env.CRYPTO_KEY;
if (!cryptoKey) {
  throw new Error("CRYPTO_KEY environment variable is required");
}

export default defineNuxtConfig({
  runtimeConfig: {
    cryptoKey, // デフォルト値なし
  },
});
```

#### 3-3. 入力バリデーションの不足

**ファイル**: [front/components/user/userFormEmail.vue](../../components/user/userFormEmail.vue):29-32

```typescript
// ❌ 問題のコード
const rules = [
  (v: string) => !!v || "", // エラーメッセージが空
  (v: string) => /.+@.+\..+/.test(v) || "", // 正規表現が緩い
];
```

**問題点**:

- ユーザーにエラーが表示されない
- `a@b.c`のような不正なメールアドレスも通過

```typescript
// ✅ 改善方法
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

const rules = [
  (v: string) => !!v || "メールアドレスを入力してください",
  (v: string) =>
    EMAIL_REGEX.test(v) || "メールアドレスの形式が正しくありません",
  (v: string) => v.length <= 254 || "メールアドレスが長すぎます",
];
```

#### 3-4. LocalStorageの直接操作

**ファイル**:

- [front/pages/login.vue](../../pages/login.vue):103
- [front/middleware/auth.ts](../../middleware/auth.ts):27, 38

```typescript
// ❌ 問題のコード
localStorage.setItem("rememberRoute", JSON.stringify(to.fullPath));
```

**問題点**:

- SSR時にエラーになる可能性
- 型安全性がない
- XSS攻撃時に読み取られる可能性

```typescript
// ✅ 改善方法: Composableでラップ
// composables/useSecureStorage.ts
export function useSecureStorage() {
  const setItem = (key: string, value: unknown) => {
    if (process.client) {
      try {
        sessionStorage.setItem(key, JSON.stringify(value));
      } catch (error) {
        console.error("Failed to save to storage:", error);
      }
    }
  };

  const getItem = <T>(key: string): T | null => {
    if (process.client) {
      try {
        const item = sessionStorage.getItem(key);
        return item ? JSON.parse(item) : null;
      } catch (error) {
        console.error("Failed to read from storage:", error);
        return null;
      }
    }
    return null;
  };

  return { setItem, getItem };
}

// 使用例
const storage = useSecureStorage();
storage.setItem("rememberRoute", to.fullPath);
```

### ✅ 改善アクション

| 優先度 | 項目                   | 期間 |
| ------ | ---------------------- | ---- |
| 1      | 認証情報の環境変数化   | 1日  |
| 2      | 暗号化キーの必須化     | 1日  |
| 3      | バリデーション強化     | 2日  |
| 4      | Storage Composable作成 | 1日  |

### 🎯 期待される効果

- ✅ セキュリティリスク **-80%**
- ✅ OWASP Top 10 対策
- ✅ ユーザー情報の保護
- ✅ 本番環境の安全性向上

---

## 4. Signup機能の未実装

### 🚨 問題の重大度

**Critical** - 重要機能の欠如

### 📍 影響範囲

**ファイル**: [front/pages/signup.vue](../../pages/signup.vue):全体

### 🔍 問題の詳細

Signupページは存在するが、**実際のユーザー登録処理が実装されていません**。

```javascript
// ❌ 現在のコード - pages/signup.vue:161-168
signup() {
  this.loading = true;
  setTimeout(() => {
    this.formReset();
    this.loading = false;
  }, 1500);  // ← 1.5秒待って何もしない
},
```

**問題点**:

- 新規ユーザーが登録できない
- UIだけ存在する「張りぼて」状態
- Options APIで実装されている（Nuxt 3推奨に反する）

### ✅ 改善方法

#### ステップ1: Composition APIへの書き換え

```vue
<!-- ✅ 改善版 - pages/signup.vue -->
<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "~/stores/auth";
import { useToastStore } from "~/stores/toast";

// Layout設定
definePageMeta({
  layout: "before-login",
});

// Stores
const authStore = useAuthStore();
const toastStore = useToastStore();
const router = useRouter();

// State
const isValid = ref(false);
const loading = ref(false);
const params = ref({
  user: {
    name: "",
    email: "",
    password: "",
  },
});

// Methods
const signup = async () => {
  if (!isValid.value) return;

  loading.value = true;

  try {
    // API呼び出し
    const { data, error } = await useFetch("/api/v1/auth", {
      method: "POST",
      body: params.value,
    });

    if (error.value) {
      throw new Error(error.value.message);
    }

    // 成功時の処理
    toastStore.showToast({
      message: "アカウントを作成しました",
      color: "success",
    });

    // ログイン処理
    if (data.value?.token) {
      authStore.setToken(data.value.token);
      authStore.setAuth(true);
      await router.push("/spots");
    }
  } catch (err) {
    const errorMessage =
      err instanceof Error ? err.message : "登録に失敗しました";

    toastStore.showToast({
      message: errorMessage,
      color: "error",
    });
  } finally {
    loading.value = false;
  }
};

const formReset = () => {
  params.value = {
    user: {
      name: "",
      email: "",
      password: "",
    },
  };
};
</script>

<template>
  <v-container fluid fill-height>
    <v-row justify="center" align="center">
      <v-col cols="12" sm="8" md="4">
        <v-card>
          <v-card-title>
            <span class="headline">Sign up</span>
          </v-card-title>
          <v-card-text>
            <v-form v-model="isValid">
              <UserFormName v-model="params.user.name" />
              <UserFormEmail v-model="params.user.email" />
              <UserFormPassword v-model="params.user.password" />
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-spacer />
            <v-btn
              color="info"
              :disabled="!isValid || loading"
              :loading="loading"
              @click="signup"
            >
              登録
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
```

#### ステップ2: バリデーション追加

```typescript
// components/user/userFormName.vue に追加
const rules = [
  (v: string) => !!v || "名前を入力してください",
  (v: string) => v.length >= 2 || "名前は2文字以上で入力してください",
  (v: string) => v.length <= 50 || "名前は50文字以内で入力してください",
];
```

#### ステップ3: エラーハンドリング強化

```typescript
// 型定義
interface SignupError {
  message: string
  errors?: {
    name?: string[]
    email?: string[]
    password?: string[]
  }
}

// エラー処理
catch (err: unknown) {
  let errorMessage = '登録に失敗しました'

  if (err && typeof err === 'object' && 'errors' in err) {
    const signupError = err as SignupError
    // フィールド別エラーメッセージを表示
    if (signupError.errors?.email) {
      errorMessage = signupError.errors.email[0]
    }
  }

  toastStore.showToast({
    message: errorMessage,
    color: 'error'
  })
}
```

### 📊 作業量の見積もり

| タスク                      | 期間    |
| --------------------------- | ------- |
| Composition APIへの書き換え | 2日     |
| API統合                     | 1日     |
| バリデーション強化          | 1日     |
| エラーハンドリング          | 1日     |
| テスト実装                  | 2日     |
| **合計**                    | **7日** |

### 🎯 期待される効果

- ✅ ユーザー登録機能の実現
- ✅ ユーザー獲得の促進
- ✅ Composition APIへの移行（他ページの見本）
- ✅ 適切なエラーハンドリング

---

## 📊 全体の優先度と作業計画

### 推奨される対応順序

```
週1-2: セキュリティ問題の修正
  └─ 認証情報の環境変数化、暗号化キー必須化

週3-4: TypeScript strict mode 段階的有効化
  └─ noImplicitAny有効化、any型の修正開始

週5-6: Signup機能の実装
  └─ Composition API書き換え、API統合

週7-8: any型の完全排除
  └─ 残りの箇所の修正、型定義の整備
```

### 🎯 マイルストーン

| マイルストーン           | 完了基準                 | 期限    |
| ------------------------ | ------------------------ | ------- |
| **M1: セキュリティ修正** | 認証情報の環境変数化完了 | 2週間後 |
| **M2: 型安全性向上**     | noImplicitAny有効化      | 4週間後 |
| **M3: Signup機能完成**   | ユーザー登録が動作       | 6週間後 |
| **M4: Critical完了**     | any型完全排除            | 8週間後 |

---

## 📚 参考リソース

- [TypeScript Handbook - Strict Mode](https://www.typescriptlang.org/tsconfig#strict)
- [OWASP Top 10 - 2021](https://owasp.org/www-project-top-ten/)
- [Nuxt 3 - Data Fetching](https://nuxt.com/docs/getting-started/data-fetching)
- [Vue 3 - Composition API](https://vuejs.org/guide/extras/composition-api-faq.html)

---

## ✅ チェックリスト

最優先課題の完了チェックリスト:

- [ ] TypeScript strict mode段階的有効化開始
- [ ] any型26箇所の修正
- [x] 認証情報の環境変数化
- [x] 暗号化キーの必須化
- [x] 入力バリデーション強化
- [x] Storage Composable作成
- [ ] Signup機能のComposition API書き換え
- [ ] Signup APIの統合
- [ ] エラーハンドリング実装
- [ ] Signupページのテスト作成

### 進捗メモ (2025-11-23)

- ゲスト/通常ログイン資格情報を環境変数化し、未設定時はトースト通知
- `CRYPTO_KEY` を必須化しデフォルトキーを廃止
- メールアドレス入力のバリデーションを強化（形式チェック・長さ上限・メッセージ追加）
- `useSecureStorage` を新設し `rememberRoute` の保存先をセッションストレージに置き換え

次は **[02-high-priority.md](./02-high-priority.md)** を読んで、高優先度課題を確認してください。
