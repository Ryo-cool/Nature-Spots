# 低優先度課題（Low Priority）

🟢 **時間があれば対応する課題**

これらの問題は、コードの可読性やメンテナンス性を向上させますが、緊急性は低い項目です。

---

## 📋 目次

1. [Console.logの整理](#1-consolelogの整理)
2. [未使用ファイルの削除](#2-未使用ファイルの削除)
3. [TODOコメントの解決](#3-todoコメントの解決)
4. [コード分割の最適化](#4-コード分割の最適化)

---

## 1. Console.logの整理

### 🚨 問題の重大度
**Low** - デバッグ情報の残存

### 📍 影響範囲
**23ファイル**でconsole.logが使用されています。

### 🔍 問題の詳細

開発中のデバッグ用console.logがプロダクションコードに残っています。

```typescript
// 例: components/spot/spotData.vue
console.log("スポットデータ:", spot)
console.log("ユーザー情報:", user)
console.error("エラー:", error)
```

**問題点**:
- 本番環境で不要な情報が出力される
- パフォーマンスへの微小な影響
- セキュリティリスク（機密情報の漏洩可能性）

### ✅ 改善方法

#### ステップ1: ロギングユーティリティの作成

```typescript
// utils/logger.ts
type LogLevel = 'debug' | 'info' | 'warn' | 'error'

interface LoggerConfig {
  enabled: boolean
  minLevel: LogLevel
  includeTimestamp: boolean
  includeContext: boolean
}

const logLevels: Record<LogLevel, number> = {
  debug: 0,
  info: 1,
  warn: 2,
  error: 3
}

class Logger {
  private config: LoggerConfig

  constructor(config: Partial<LoggerConfig> = {}) {
    const isDev = process.env.NODE_ENV === 'development'

    this.config = {
      enabled: isDev,
      minLevel: isDev ? 'debug' : 'warn',
      includeTimestamp: true,
      includeContext: true,
      ...config
    }
  }

  private shouldLog(level: LogLevel): boolean {
    if (!this.config.enabled) return false
    return logLevels[level] >= logLevels[this.config.minLevel]
  }

  private format(level: LogLevel, message: string, context?: string): string {
    const parts: string[] = []

    if (this.config.includeTimestamp) {
      parts.push(`[${new Date().toISOString()}]`)
    }

    parts.push(`[${level.toUpperCase()}]`)

    if (context && this.config.includeContext) {
      parts.push(`[${context}]`)
    }

    parts.push(message)

    return parts.join(' ')
  }

  debug(message: string, data?: any, context?: string) {
    if (!this.shouldLog('debug')) return
    console.log(this.format('debug', message, context), data || '')
  }

  info(message: string, data?: any, context?: string) {
    if (!this.shouldLog('info')) return
    console.info(this.format('info', message, context), data || '')
  }

  warn(message: string, data?: any, context?: string) {
    if (!this.shouldLog('warn')) return
    console.warn(this.format('warn', message, context), data || '')
  }

  error(message: string, error?: any, context?: string) {
    if (!this.shouldLog('error')) return
    console.error(this.format('error', message, context), error || '')
  }
}

export const logger = new Logger()
```

#### ステップ2: 既存のconsole.logを置き換え

```typescript
// ❌ Before
console.log("スポットデータ:", spot)
console.error("エラー:", error)

// ✅ After
import { logger } from '~/utils/logger'

logger.debug('スポットデータを取得', spot, 'SpotData')
logger.error('スポット取得に失敗', error, 'SpotData')
```

#### ステップ3: ビルド時の自動削除設定

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  vite: {
    esbuild: {
      drop: process.env.NODE_ENV === 'production'
        ? ['console', 'debugger']
        : []
    }
  }
})
```

または、プラグインを使用:

```bash
yarn add -D vite-plugin-remove-console
```

```typescript
// nuxt.config.ts
import removeConsole from 'vite-plugin-remove-console'

export default defineNuxtConfig({
  vite: {
    plugins: [
      removeConsole({
        includes: ['log', 'debug', 'info']  // warn, errorは残す
      })
    ]
  }
})
```

### 📋 整理対象ファイル（主要なもの）

| ファイル | console使用箇所 | 優先度 |
|---------|----------------|--------|
| stores/spot.ts | 3箇所 | 中 |
| components/spot/spotData.vue | 5箇所 | 中 |
| pages/newspots.vue | 4箇所 | 低 |
| その他 | 約40箇所 | 低 |

### 📊 作業量の見積もり

| タスク | 期間 |
|-------|------|
| Loggerユーティリティ作成 | 0.5日 |
| 主要ファイルの置き換え | 1日 |
| ビルド設定の追加 | 0.5日 |
| **合計** | **2日** |

### 🎯 期待される効果

- ✅ 本番環境でのログ出力制御
- ✅ 構造化されたログ
- ✅ デバッグの効率化
- ✅ セキュリティリスクの軽減

---

## 2. 未使用ファイルの削除

### 🚨 問題の重大度
**Low** - コードベースの肥大化

### 📍 影響範囲

#### 未使用のミドルウェアファイル

1. **[front/middleware/authenticator.js](../../middleware/authenticator.js)**
   - Nuxt 2用の古いミドルウェア
   - 現在は`auth.ts`が使用されている

2. **[front/middleware/loggedInIsRedirects.js](../../middleware/loggedInIsRedirects.js)**
   - 使用されていない旧ミドルウェア

### 🔍 問題の詳細

```javascript
// middleware/authenticator.js - Nuxt 2スタイル
export default async ({ $auth, $axios, store, route, redirect }) => {
  // 古いコード...
}
```

**問題点**:
- コードベースの混乱
- 誤って使用される可能性
- メンテナンスコストの増加

### ✅ 改善方法

#### ステップ1: 未使用ファイルの特定

```bash
# 未使用ファイルの検索ツールを使用
npx unimported

# または手動で検索
git ls-files | while read file; do
  if ! git grep -q "$(basename $file .js)" -- '*.vue' '*.ts' '*.js'; then
    echo "未使用の可能性: $file"
  fi
done
```

#### ステップ2: 削除前の確認

```bash
# 1. ファイルがどこからも参照されていないか確認
grep -r "authenticator" front/

# 2. Gitの履歴を確認（最後の変更日）
git log --oneline front/middleware/authenticator.js

# 3. バックアップ（念のため）
git checkout -b cleanup/remove-unused-files
```

#### ステップ3: 削除実行

```bash
# 未使用ミドルウェアの削除
rm front/middleware/authenticator.js
rm front/middleware/loggedInIsRedirects.js

# コミット
git add .
git commit -m "chore: 未使用のミドルウェアファイルを削除"
```

### 📋 削除候補ファイルリスト

| ファイル | 理由 | 確認方法 |
|---------|------|---------|
| middleware/authenticator.js | Nuxt 2用、未使用 | `grep -r "authenticator"` |
| middleware/loggedInIsRedirects.js | 未使用 | `grep -r "loggedInIsRedirects"` |

### 📊 作業量の見積もり

| タスク | 期間 |
|-------|------|
| 未使用ファイルの特定 | 0.5日 |
| 削除とテスト | 0.5日 |
| **合計** | **1日** |

### 🎯 期待される効果

- ✅ コードベースの整理
- ✅ ビルドサイズの微減
- ✅ 開発者の混乱防止
- ✅ メンテナンス性の向上

---

## 3. TODOコメントの解決

### 🚨 問題の重大度
**Low** - 未完了タスクの残存

### 📍 影響範囲

#### TODOコメント一覧

1. **[front/components/userPage/followBtn.vue](../../components/userPage/followBtn.vue):83**
   ```typescript
   // TODO: 初期フォロー状態を取得する処理を追加
   ```

2. **[front/middleware/authenticator.js](../../middleware/authenticator.js):20**
   ```javascript
   // TODO トースター出力
   ```

### 🔍 問題の詳細

TODOコメントは開発中の備忘録として有用ですが、長期間残ると：
- 実装が忘れられる
- コードの不完全性が不明確
- 技術的負債の蓄積

### ✅ 改善方法

#### ケース1: フォローボタンの初期状態取得

```vue
<!-- components/userPage/followBtn.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue'

interface Props {
  userId: number
}

const props = defineProps<Props>()

const isFollowing = ref(false)
const loading = ref(false)

// ✅ TODO解決: 初期フォロー状態を取得
onMounted(async () => {
  await fetchFollowStatus()
})

const fetchFollowStatus = async () => {
  try {
    loading.value = true
    const { data } = await useFetch<{ is_following: boolean }>(
      `/api/v1/users/${props.userId}/follow_status`
    )
    isFollowing.value = data.value?.is_following || false
  } catch (error) {
    logger.error('フォロー状態の取得に失敗', error, 'FollowBtn')
  } finally {
    loading.value = false
  }
}

const toggleFollow = async () => {
  try {
    loading.value = true
    if (isFollowing.value) {
      await $fetch(`/api/v1/users/${props.userId}/unfollow`, {
        method: 'DELETE'
      })
      isFollowing.value = false
    } else {
      await $fetch(`/api/v1/users/${props.userId}/follow`, {
        method: 'POST'
      })
      isFollowing.value = true
    }
  } catch (error) {
    logger.error('フォロー操作に失敗', error, 'FollowBtn')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <v-btn
    :color="isFollowing ? 'grey' : 'primary'"
    :loading="loading"
    @click="toggleFollow"
  >
    {{ isFollowing ? 'フォロー中' : 'フォローする' }}
  </v-btn>
</template>
```

#### ケース2: 未使用ファイル内のTODO

```javascript
// middleware/authenticator.js:20
// TODO トースター出力

// ✅ 解決方法: このファイル自体が未使用なので削除
```

#### ステップ3: TODO管理の改善

```typescript
// .vscode/settings.json
{
  "todo-tree.general.tags": [
    "TODO",
    "FIXME",
    "BUG",
    "HACK",
    "NOTE"
  ],
  "todo-tree.highlights.defaultHighlight": {
    "foreground": "white",
    "background": "orange",
    "icon": "check"
  }
}
```

### 📋 TODOコメント管理方針

#### 許容されるTODO
```typescript
// TODO(username): 2025-12-31までにAPI v2に移行
// 期限と担当者が明確
```

#### 推奨しないTODO
```typescript
// TODO: いつか修正する
// 曖昧で期限なし
```

#### GitHub Issueへの移行
```typescript
// TODO: → GitHub Issue #123に移行
// 長期的なタスクはIssueトラッカーで管理
```

### 📊 作業量の見積もり

| TODO項目 | 期間 |
|---------|------|
| フォローボタンの実装 | 1日 |
| その他のTODO解決 | 0.5日 |
| **合計** | **1.5日** |

### 🎯 期待される効果

- ✅ 機能の完全実装
- ✅ コードの完成度向上
- ✅ タスク管理の明確化
- ✅ 技術的負債の削減

---

## 4. コード分割の最適化

### 🚨 問題の重大度
**Low** - 初期読み込み時間への影響

### 📍 現状
- 動的import（`defineAsyncComponent`）の使用: ほぼなし
- すべてのコンポーネントが同期的にロード
- ページレベルのコード分割が不十分

### 🔍 問題の詳細

```typescript
// ❌ すべて同期的にインポート
import SpotCard from '~/components/spot/spotCard.vue'
import SpotData from '~/components/spot/spotData.vue'
import Reviews from '~/components/spot/reviews.vue'
```

**問題点**:
- 初期バンドルサイズが大きい
- 使用しないコンポーネントもロード
- First Contentful Paint (FCP)が遅い

### ✅ 改善方法

#### パターン1: 重いコンポーネントの遅延読み込み

```vue
<!-- ✅ pages/spots/_id/index.vue -->
<script setup lang="ts">
// 軽いコンポーネントは通常インポート
import SpotHeader from '~/components/spot/spotHeader.vue'

// 重いコンポーネントは動的インポート
const GoogleMap = defineAsyncComponent(() =>
  import('~/components/spot/GoogleMap.vue')
)

const Reviews = defineAsyncComponent(() =>
  import('~/components/spot/reviews.vue')
)
</script>

<template>
  <div>
    <!-- すぐに表示 -->
    <SpotHeader :spot="spot" />

    <!-- 遅延読み込み（ローディング表示付き） -->
    <Suspense>
      <template #default>
        <GoogleMap :location="spot.location" />
      </template>
      <template #fallback>
        <div class="loading">地図を読み込み中...</div>
      </template>
    </Suspense>

    <Suspense>
      <template #default>
        <Reviews :spot-id="spot.id" />
      </template>
      <template #fallback>
        <v-skeleton-loader type="card" />
      </template>
    </Suspense>
  </div>
</template>
```

#### パターン2: ルートレベルのコード分割

```typescript
// ✅ nuxt.config.ts
export default defineNuxtConfig({
  vite: {
    build: {
      rollupOptions: {
        output: {
          manualChunks: {
            // Vuetifyを別チャンクに
            'vuetify': ['vuetify'],
            // Google Maps関連を別チャンクに
            'maps': ['google-maps-api-loader'],
            // 大きなライブラリを分割
            'vendor': ['pinia', 'vue-i18n']
          }
        }
      }
    }
  }
})
```

#### パターン3: 条件付き読み込み

```vue
<!-- ✅ 管理者のみが使う機能を遅延読み込み -->
<script setup lang="ts">
const authStore = useAuthStore()

const AdminPanel = computed(() => {
  if (authStore.user?.isAdmin) {
    return defineAsyncComponent(() =>
      import('~/components/admin/AdminPanel.vue')
    )
  }
  return null
})
</script>

<template>
  <component
    v-if="AdminPanel"
    :is="AdminPanel"
  />
</template>
```

#### パターン4: プリフェッチの活用

```vue
<!-- ✅ ユーザーがホバーしたらプリフェッチ -->
<script setup lang="ts">
const isHovering = ref(false)

const prefetchReviews = () => {
  // コンポーネントをプリフェッチ
  import('~/components/spot/reviews.vue')
}
</script>

<template>
  <div @mouseenter="prefetchReviews">
    <button @click="isHovering = true">
      レビューを表示
    </button>

    <component
      v-if="isHovering"
      :is="Reviews"
    />
  </div>
</template>
```

### 📋 最適化候補コンポーネント

| コンポーネント | サイズ | 優先度 | 方法 |
|--------------|--------|--------|------|
| GoogleMap | 大 | 高 | 遅延読み込み |
| Reviews | 中 | 中 | 遅延読み込み |
| AdminPanel | 中 | 高 | 条件付き読み込み |
| ImageGallery | 中 | 中 | プリフェッチ |
| ChartComponent | 大 | 低 | 遅延読み込み |

### 📊 バンドル分析

```bash
# バンドルサイズを分析
yarn add -D rollup-plugin-visualizer

# 分析レポート生成
yarn build --analyze
```

```typescript
// nuxt.config.ts
import { visualizer } from 'rollup-plugin-visualizer'

export default defineNuxtConfig({
  vite: {
    plugins: [
      visualizer({
        filename: './dist/stats.html',
        open: true
      })
    ]
  }
})
```

### 📊 作業量の見積もり

| タスク | 期間 |
|-------|------|
| バンドル分析 | 0.5日 |
| 重要コンポーネントの遅延読み込み | 1日 |
| ルートレベルの最適化 | 0.5日 |
| パフォーマンス測定 | 0.5日 |
| **合計** | **2.5日** |

### 🎯 期待される効果

- ✅ 初期バンドルサイズ **-25%**
- ✅ First Contentful Paint **-20%**
- ✅ Lighthouse Performance スコア向上
- ✅ ユーザー体験の改善

---

## 📊 低優先度課題の全体スケジュール

### 推奨される実装順序

```
週1: Console.log整理
  ├─ Loggerユーティリティ作成
  ├─ 主要ファイルの置き換え
  └─ ビルド設定

週2: 未使用ファイル削除 + TODO解決
  ├─ 未使用ファイルの特定と削除
  ├─ フォローボタン実装
  └─ その他TODO解決

週3: コード分割最適化
  ├─ バンドル分析
  ├─ 遅延読み込み実装
  └─ パフォーマンス測定
```

### 🎯 完了基準

- [ ] 本番環境でconsole.log出力なし
- [ ] 未使用ファイルが0件
- [ ] TODOコメントが0件（またはIssue化）
- [ ] 初期バンドルサイズが目標値以下

### 📈 期待される総合効果

| 指標 | 改善目標 |
|------|---------|
| バンドルサイズ | -25% |
| ビルド時間 | -10% |
| コード可読性 | 向上 |
| メンテナンス性 | 向上 |

---

## 📝 補足: 優先度の再評価

以下の状況では、低優先度課題の優先度を上げることを検討してください：

### Console.log → High
- セキュリティ監査で指摘された場合
- 本番環境で機密情報が漏洩するリスクがある場合

### 未使用ファイル → Medium
- リファクタリング中で混乱を招いている場合
- ビルド時間が著しく長い場合

### TODO → High
- TODOが重要な機能に関わる場合
- リリース前の確認で発見された場合

### コード分割 → High
- Lighthouse スコアが60点以下の場合
- ユーザーから読み込みが遅いという報告が多い場合

次は **[05-implementation-roadmap.md](./05-implementation-roadmap.md)** を読んで、実装ロードマップを確認してください。
