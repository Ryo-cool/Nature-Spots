# 中優先度課題（Medium Priority）

🟡 **計画的に対応すべき課題**

これらの問題は、品質向上と将来的なリスク軽減のために、計画的に対応することが推奨されます。

---

## 📋 目次

1. [メモリリーク対策](#1-メモリリーク対策)
2. [アクセシビリティ対応](#2-アクセシビリティ対応)
3. [画像最適化の全面適用](#3-画像最適化の全面適用)
4. [Props/Emitsの型定義強化](#4-propsemitsの型定義強化)

---

## 1. メモリリーク対策

### 🚨 問題の重大度
**Medium** - パフォーマンス問題、メモリ使用量の増加

### 📍 影響範囲
**ファイル**: [front/stores/toast.ts](../../stores/toast.ts):28-31

### 🔍 問題の詳細

ToastストアでsetTimeoutを使用していますが、タイマーIDが保存されていないため、コンポーネントがアンマウントされてもタイマーが残る可能性があります。

```typescript
// ❌ 問題のコード
showToast({ message, color = "info", timeout = 3000 }: ToastMessage) {
  this.show = true;
  this.message = message;
  this.color = color;
  this.timeout = timeout;

  if (timeout > 0) {
    setTimeout(() => {
      this.clearToast();
    }, timeout);  // ← タイマーIDが保存されていない
  }
}
```

**問題点**:
- タイマーをキャンセルできない
- 複数回呼ばれると古いタイマーが残る
- メモリリークの可能性

**影響**:
- 長時間利用でメモリ使用量が増加
- 予期しないToast表示

### ✅ 改善方法

```typescript
// ✅ 改善版 - stores/toast.ts
import { defineStore } from "pinia";

interface ToastMessage {
  message: string;
  color?: "success" | "error" | "warning" | "info";
  timeout?: number;
}

export const useToastStore = defineStore("toast", {
  state: () => ({
    show: false,
    message: "",
    color: "info" as "success" | "error" | "warning" | "info",
    timeout: 3000,
    timeoutId: null as number | null,  // ← タイマーID保存
  }),

  actions: {
    showToast({ message, color = "info", timeout = 3000 }: ToastMessage) {
      // 既存のタイマーをクリア
      if (this.timeoutId !== null) {
        clearTimeout(this.timeoutId);
        this.timeoutId = null;
      }

      this.show = true;
      this.message = message;
      this.color = color;
      this.timeout = timeout;

      if (timeout > 0) {
        this.timeoutId = setTimeout(() => {
          this.clearToast();
          this.timeoutId = null;
        }, timeout) as unknown as number;
      }
    },

    clearToast() {
      // タイマーをクリア
      if (this.timeoutId !== null) {
        clearTimeout(this.timeoutId);
        this.timeoutId = null;
      }

      this.show = false;
      this.message = "";
      this.color = "info";
      this.timeout = 3000;
    },
  },
});
```

### 📊 その他のメモリリーク可能性箇所

#### 2. イベントリスナーの未クリーンアップ

**対象**: Google Maps関連のコンポーネント

```typescript
// ❌ 問題の可能性
onMounted(() => {
  window.addEventListener('resize', handleResize)
})

// ✅ 改善
onMounted(() => {
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
})
```

#### 3. Watcherの未停止

```typescript
// ❌ 問題の可能性
watch(someRef, () => {
  // 処理
})

// ✅ 改善
const stopWatch = watch(someRef, () => {
  // 処理
})

onUnmounted(() => {
  stopWatch()
})
```

### 📋 対策チェックリスト

全コンポーネントで以下を確認:

- [ ] setTimeoutのタイマーID管理
- [ ] setIntervalのタイマーID管理
- [ ] イベントリスナーのクリーンアップ
- [ ] Watcherの停止
- [ ] API呼び出しのキャンセル処理

### 📊 作業量の見積もり

| タスク | 期間 |
|-------|------|
| Toast Store修正 | 0.5日 |
| 全コンポーネント調査 | 1日 |
| メモリリーク箇所修正 | 1日 |
| **合計** | **2.5日** |

### 🎯 期待される効果

- ✅ メモリ使用量の安定化
- ✅ 長時間利用時のパフォーマンス維持
- ✅ 予期しない動作の防止

---

## 2. アクセシビリティ対応

### 🚨 問題の重大度
**Medium** - ユーザーアクセシビリティの欠如

### 📍 現状
- **ARIA属性使用**: 0ファイル
- **セマンティックHTML**: 不十分
- **キーボード操作**: 未対応箇所あり

### 🔍 問題の詳細

#### 問題1: ARIA属性の欠如

```vue
<!-- ❌ 問題のコード -->
<!-- components/loggedIn/header/loggedInAppBar.vue -->
<v-btn icon v-bind="props">
  <v-icon>mdi-account</v-icon>
  <!-- スクリーンリーダーで「ボタン」としか読まれない -->
</v-btn>
```

#### 問題2: セマンティックHTMLの不足

```vue
<!-- ❌ 問題のコード -->
<div @click="handleClick">クリック</div>

<!-- ✅ 改善 -->
<button @click="handleClick">クリック</button>
```

#### 問題3: フォームラベルの不足

```vue
<!-- ❌ 問題のコード -->
<v-text-field
  v-model="email"
  placeholder="メールアドレス"
/>

<!-- ✅ 改善 -->
<v-text-field
  v-model="email"
  label="メールアドレス"
  aria-label="メールアドレスを入力"
  aria-describedby="email-help"
/>
<span id="email-help" class="text-caption">
  ログインに使用するメールアドレスを入力してください
</span>
```

### ✅ 改善方法

#### ステップ1: ARIA属性の追加

```vue
<!-- ✅ 改善版 - loggedInAppBar.vue -->
<script setup lang="ts">
const { t } = useI18n()
</script>

<template>
  <!-- アイコンボタン -->
  <v-btn
    icon
    :aria-label="t('common.userMenu')"
    v-bind="props"
  >
    <v-icon>mdi-account</v-icon>
  </v-btn>

  <!-- ナビゲーション -->
  <nav aria-label="メインナビゲーション">
    <v-list>
      <v-list-item
        to="/spots"
        :aria-label="t('nav.spots')"
      >
        {{ t('nav.spots') }}
      </v-list-item>
    </v-list>
  </nav>

  <!-- ローディング -->
  <div
    v-if="loading"
    role="status"
    aria-live="polite"
    aria-busy="true"
  >
    {{ t('common.loading') }}
  </div>
</template>
```

#### ステップ2: キーボード操作対応

```vue
<!-- ✅ カスタムコンポーネントのキーボード対応 -->
<script setup lang="ts">
const handleKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault()
    handleClick()
  }
}
</script>

<template>
  <div
    role="button"
    tabindex="0"
    @click="handleClick"
    @keydown="handleKeydown"
    :aria-label="label"
  >
    {{ text }}
  </div>
</template>
```

#### ステップ3: フォーカス管理

```vue
<!-- ✅ モーダルのフォーカストラップ -->
<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const modalRef = ref<HTMLElement | null>(null)
const previousActiveElement = ref<HTMLElement | null>(null)

onMounted(() => {
  // 前のフォーカス位置を保存
  previousActiveElement.value = document.activeElement as HTMLElement

  // モーダル内の最初のフォーカス可能要素にフォーカス
  const firstFocusable = modalRef.value?.querySelector(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  ) as HTMLElement
  firstFocusable?.focus()
})

onUnmounted(() => {
  // フォーカスを元の位置に戻す
  previousActiveElement.value?.focus()
})
</script>

<template>
  <div
    ref="modalRef"
    role="dialog"
    aria-modal="true"
    :aria-labelledby="titleId"
  >
    <h2 :id="titleId">{{ title }}</h2>
    <!-- モーダルコンテンツ -->
  </div>
</template>
```

#### ステップ4: エラーメッセージのアクセシビリティ

```vue
<!-- ✅ アクセシブルなエラー表示 -->
<script setup lang="ts">
const error = ref('')
const errorId = 'email-error'
</script>

<template>
  <v-text-field
    v-model="email"
    label="メールアドレス"
    :error-messages="error"
    :aria-describedby="error ? errorId : undefined"
    :aria-invalid="!!error"
  />
  <div
    v-if="error"
    :id="errorId"
    role="alert"
    aria-live="assertive"
    class="text-error"
  >
    {{ error }}
  </div>
</template>
```

### 📋 アクセシビリティチェックリスト

#### 必須対応

- [ ] すべてのボタンに`aria-label`または適切なテキスト
- [ ] フォーム要素に`label`または`aria-label`
- [ ] エラーメッセージに`role="alert"`
- [ ] ローディング状態に`aria-live`
- [ ] モーダルに`role="dialog"`と`aria-modal`
- [ ] キーボードで全機能が操作可能

#### 推奨対応

- [ ] 見出しの階層が正しい（h1→h2→h3）
- [ ] ランドマーク（`<nav>`, `<main>`, `<aside>`）の使用
- [ ] `alt`属性のある画像
- [ ] コントラスト比の確保（WCAG AA: 4.5:1以上）

### 📊 実装計画

| フェーズ | 内容 | 期間 |
|---------|------|------|
| 1 | 重要コンポーネント（ヘッダー、フォーム） | 2日 |
| 2 | ナビゲーション、モーダル | 2日 |
| 3 | その他のコンポーネント | 2日 |
| 4 | キーボード操作テスト | 1日 |
| **合計** | - | **7日** |

### 🔧 ツールの導入

```bash
# アクセシビリティ検証ツール
yarn add -D @axe-core/vue
yarn add -D eslint-plugin-vuejs-accessibility
```

```typescript
// .eslintrc.js に追加
module.exports = {
  extends: [
    'plugin:vuejs-accessibility/recommended'
  ]
}
```

### 🎯 期待される効果

- ✅ スクリーンリーダー対応
- ✅ キーボード操作の完全対応
- ✅ WCAG 2.1 レベルAA準拠
- ✅ より多くのユーザーが利用可能

---

## 3. 画像最適化の全面適用

### 🚨 問題の重大度
**Medium** - パフォーマンスへの影響

### 📍 現状
- `OptimizedImage`コンポーネントは存在
- **実際の使用**: 一部のみ
- **直接`<v-img>`使用**: 多数

### 🔍 問題の詳細

#### 未最適化の箇所

```vue
<!-- ❌ 問題のコード - components/spot/reviews.vue:28 -->
<v-img
  :src="review.image_url"
  aspect-ratio="1"
  class="grey lighten-2"
/>

<!-- ❌ 問題のコード - components/loggedIn/header/loggedInAppBar.vue:50 -->
<v-img
  :src="user.avatar_url"
  alt="User avatar"
/>
```

**問題点**:
- 画像サイズの最適化なし
- 遅延読み込みなし
- WebP等の最適フォーマット未使用
- Placeholder未設定

### ✅ 改善方法

#### ステップ1: OptimizedImageコンポーネントの確認・改善

```vue
<!-- components/ui/OptimizedImage.vue -->
<script setup lang="ts">
interface Props {
  src: string
  alt: string
  width?: number
  height?: number
  aspectRatio?: number | string
  lazy?: boolean
  placeholder?: string
}

const props = withDefaults(defineProps<Props>(), {
  lazy: true,
  placeholder: '/images/placeholder.svg'
})

// WebP対応確認
const supportsWebP = ref(false)
onMounted(() => {
  const img = new Image()
  img.onload = () => {
    supportsWebP.value = img.width === 1
  }
  img.src = 'data:image/webp;base64,UklGRiQAAABXRUJQVlA4IBgAAAAwAQCdASoBAAEAAwA0JaQAA3AA/vuUAAA='
})

const optimizedSrc = computed(() => {
  if (!props.src) return props.placeholder

  // 画像最適化サービスを使用する場合
  // return `https://image-optimizer.example.com/${props.src}?w=${props.width}&format=webp`

  return props.src
})
</script>

<template>
  <v-img
    :src="optimizedSrc"
    :alt="alt"
    :width="width"
    :height="height"
    :aspect-ratio="aspectRatio"
    :lazy-src="placeholder"
    :loading="lazy ? 'lazy' : 'eager'"
    class="optimized-image"
  >
    <template #placeholder>
      <v-row
        class="fill-height ma-0"
        align="center"
        justify="center"
      >
        <v-progress-circular
          indeterminate
          color="grey lighten-5"
        />
      </v-row>
    </template>
  </v-img>
</template>

<style scoped>
.optimized-image {
  background-color: #f5f5f5;
}
</style>
```

#### ステップ2: 既存コードの置き換え

```vue
<!-- ✅ 改善版 - components/spot/reviews.vue -->
<script setup lang="ts">
import OptimizedImage from '~/components/ui/OptimizedImage.vue'
</script>

<template>
  <OptimizedImage
    :src="review.image_url"
    :alt="`${review.user.name}のレビュー画像`"
    :aspect-ratio="1"
    :width="400"
    :height="400"
  />
</template>
```

```vue
<!-- ✅ 改善版 - components/loggedIn/header/loggedInAppBar.vue -->
<OptimizedImage
  :src="user.avatar_url"
  :alt="`${user.name}のアバター`"
  :width="40"
  :height="40"
  :aspect-ratio="1"
  class="rounded-circle"
/>
```

#### ステップ3: 画像CDN/最適化サービスの導入（オプション）

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  image: {
    // Nuxt Imageモジュールを使用
    domains: ['example.com'],
    screens: {
      xs: 320,
      sm: 640,
      md: 768,
      lg: 1024,
      xl: 1280,
      xxl: 1536,
    },
    format: ['webp', 'jpg'],
  }
})
```

```bash
# Nuxt Imageモジュールのインストール
yarn add @nuxt/image
```

```vue
<!-- Nuxt Imageを使用する場合 -->
<NuxtImg
  :src="spot.image_url"
  :alt="spot.name"
  width="800"
  height="600"
  format="webp"
  loading="lazy"
  placeholder
/>
```

### 📋 置き換え対象ファイル

| ファイル | `<v-img>`使用箇所 | 優先度 |
|---------|------------------|--------|
| components/spot/reviews.vue | 1箇所 | 高 |
| components/loggedIn/header/loggedInAppBar.vue | 1箇所 | 高 |
| pages/spots/_id/index.vue | 2箇所 | 高 |
| components/spot/spotCard.vue | 1箇所 | 中 |
| その他 | 約10箇所 | 低 |

### 📊 作業量の見積もり

| タスク | 期間 |
|-------|------|
| OptimizedImageコンポーネント改善 | 0.5日 |
| 高優先度ファイル置き換え | 1日 |
| その他ファイル置き換え | 1.5日 |
| Nuxt Image導入（オプション） | 1日 |
| **合計** | **3-4日** |

### 🎯 期待される効果

- ✅ ページ読み込み速度 **-30%**
- ✅ 画像データ転送量 **-40%**（WebP使用時）
- ✅ Lighthouse スコア向上
- ✅ ユーザー体験の改善

---

## 4. Props/Emitsの型定義強化

### 🚨 問題の重大度
**Medium** - 型安全性の不足、保守性の低下

### 📍 現状
- Props定義が緩い（ランタイムバリデーションのみ）
- TypeScriptインターフェースを使用していない
- `defineEmits`が3ファイルのみで使用

### 🔍 問題の詳細

```vue
<!-- ❌ 問題のコード - components/user/userFormEmail.vue -->
<script setup lang="ts">
const props = defineProps({
  modelValue: {
    type: String,
    default: "",
  },
  noValidation: {
    type: Boolean,
    default: false,
  },
});

// emitが型定義されていない
const emit = defineEmits(["update:modelValue"]);
</script>
```

**問題点**:
- 型推論が弱い
- IDEの補完が不正確
- リファクタリング時のエラー検出が遅れる

### ✅ 改善方法

#### パターン1: TypeScriptベースのProps定義

```vue
<!-- ✅ 改善版 - components/user/userFormEmail.vue -->
<script setup lang="ts">
// Propsインターフェース
interface Props {
  modelValue: string
  noValidation?: boolean
  placeholder?: string
  label?: string
  disabled?: boolean
}

// デフォルト値付きProps
const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
  noValidation: false,
  placeholder: 'メールアドレスを入力',
  label: 'メールアドレス',
  disabled: false
})

// Emitsの型定義
interface Emits {
  (e: 'update:modelValue', value: string): void
  (e: 'blur'): void
  (e: 'focus'): void
}

const emit = defineEmits<Emits>()

// 使用例
const handleInput = (value: string) => {
  emit('update:modelValue', value)
}
</script>
```

#### パターン2: 複雑なProps型

```vue
<!-- ✅ スポットコンポーネントの例 -->
<script setup lang="ts">
import type { Spot, User } from '~/types'

interface Props {
  spot: Spot
  showActions?: boolean
  variant?: 'default' | 'compact' | 'detailed'
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showActions: true,
  variant: 'default',
  loading: false
})

interface Emits {
  (e: 'like', spotId: number): void
  (e: 'delete', spotId: number): void
  (e: 'edit', spot: Spot): void
}

const emit = defineEmits<Emits>()
</script>
```

#### パターン3: ジェネリックProps

```vue
<!-- ✅ 汎用リストコンポーネント -->
<script setup lang="ts" generic="T extends { id: number }">
interface Props {
  items: T[]
  loading?: boolean
  emptyMessage?: string
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  emptyMessage: 'データがありません'
})

interface Emits {
  (e: 'select', item: T): void
}

const emit = defineEmits<Emits>()
</script>

<template>
  <div>
    <div v-if="loading">読み込み中...</div>
    <div v-else-if="items.length === 0">{{ emptyMessage }}</div>
    <div v-else>
      <div
        v-for="item in items"
        :key="item.id"
        @click="emit('select', item)"
      >
        <slot :item="item" />
      </div>
    </div>
  </div>
</template>
```

### 📋 改善対象コンポーネント

#### 優先度高

1. **フォーム系コンポーネント**
   - [components/user/userFormEmail.vue](../../components/user/userFormEmail.vue)
   - [components/user/userFormPassword.vue](../../components/user/userFormPassword.vue)
   - [components/user/userFormName.vue](../../components/user/userFormName.vue)

2. **スポット系コンポーネント**
   - [components/spot/spotCard.vue](../../components/spot/spotCard.vue)
   - [components/spot/spotData.vue](../../components/spot/spotData.vue)
   - [components/spot/reviews.vue](../../components/spot/reviews.vue)

#### 優先度中

3. **UI系コンポーネント**
   - components/ui/ToastNotification.vue
   - components/ui/OptimizedImage.vue

### 🔄 移行手順

#### ステップ1: 型定義の作成

```typescript
// types/components.ts
import type { Spot, User, Review } from './index'

// SpotCard Props
export interface SpotCardProps {
  spot: Spot
  showActions?: boolean
  compact?: boolean
}

// SpotCard Emits
export interface SpotCardEmits {
  (e: 'like', spotId: number): void
  (e: 'delete', spotId: number): void
  (e: 'click', spot: Spot): void
}

// UserForm Props
export interface UserFormProps {
  modelValue: string
  label?: string
  placeholder?: string
  disabled?: boolean
  readonly?: boolean
}

// UserForm Emits
export interface UserFormEmits {
  (e: 'update:modelValue', value: string): void
  (e: 'blur'): void
}
```

#### ステップ2: コンポーネントの更新

```vue
<!-- components/spot/spotCard.vue -->
<script setup lang="ts">
import type { SpotCardProps, SpotCardEmits } from '~/types/components'

const props = withDefaults(defineProps<SpotCardProps>(), {
  showActions: true,
  compact: false
})

const emit = defineEmits<SpotCardEmits>()

const handleLike = () => {
  emit('like', props.spot.id)
}
</script>
```

### 📊 作業量の見積もり

| カテゴリ | コンポーネント数 | 期間 |
|---------|----------------|------|
| フォーム系 | 5個 | 1日 |
| スポット系 | 6個 | 1.5日 |
| UI系 | 4個 | 1日 |
| その他 | 10個 | 2日 |
| **合計** | **25個** | **5.5日** |

### 🎯 期待される効果

- ✅ 型安全性の向上
- ✅ IDEの補完精度向上
- ✅ リファクタリングの安全性向上
- ✅ バグの早期発見
- ✅ ドキュメントとしての役割

---

## 📊 中優先度課題の全体スケジュール

### 推奨される実装順序

```
週1: メモリリーク対策
  ├─ Toast Store修正
  ├─ タイマー管理の統一
  └─ イベントリスナークリーンアップ

週2-3: Props/Emits型定義
  ├─ 型定義ファイル作成
  ├─ フォーム系コンポーネント修正
  └─ その他コンポーネント修正

週4-5: 画像最適化
  ├─ OptimizedImage改善
  ├─ 全ファイル置き換え
  └─ パフォーマンス測定

週6-8: アクセシビリティ対応
  ├─ ARIA属性追加
  ├─ キーボード操作対応
  ├─ フォーカス管理
  └─ アクセシビリティテスト
```

### 🎯 完了基準

- [ ] メモリリーク箇所が0
- [ ] 全コンポーネントにARIA属性
- [ ] 全画像が最適化済み
- [ ] 全Props/Emitsが型定義済み
- [ ] WCAG 2.1 AA準拠

### 📈 期待される総合効果

| 指標 | 改善目標 |
|------|---------|
| メモリ使用量 | -20% |
| 画像読み込み時間 | -30% |
| アクセシビリティスコア | 90点以上 |
| 型エラー検出率 | +50% |

次は **[04-low-priority.md](./04-low-priority.md)** を読んで、低優先度課題を確認してください。
