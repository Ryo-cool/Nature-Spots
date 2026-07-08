# Nature-Spots リファクタリング計画

**調査日**: 2026-07-08  
**対象**: `front/`（Nuxt 3）+ `back/`（Rails 7）  
**前提**: 既存の `front/docs/improvements/`（2025-11-22）は Critical 項目の多くが完了済み。本計画は **現状コードベース** に基づく更新版。

---

## 1. 現状サマリー

### すでに完了していること（再実施不要）

| 領域 | 完了内容 |
|------|----------|
| Frontend | TypeScript `strict: true` / `noImplicitAny` 有効化 |
| Frontend | Signup 実装、ゲスト認証の環境変数化、`useSecureStorage` |
| Frontend | 主要ページの一部 Composition API 化（login / signup / spot 詳細） |
| Backend | N+1 対策の一部、counter cache、ページネーション、Rack::Attack |
| Backend | SpotPolicy + Authorization concern の導入開始 |

### いま残っている最大のリスク

```
Critical ─── コア機能の実行時障害・認可穴
  ├─ Front: $axios / $auth 残存（投稿・お気に入り・設定など）
  ├─ Back:  relationships の active_relationships 未定義
  ├─ Back:  Users#update に本人チェックなし
  ├─ Back:  Users#create 未実装（signup 契約と不一致）
  └─ Back:  spot_seasons が schema.rb 未反映

High ─────── 保守性・契約の不安定さ
  ├─ Front: API 呼び出し三重構造（$fetch / $api / 未使用 spot store）
  ├─ Front: 認証の二重管理（useAuth ↔ authStore）
  ├─ Front/Back: API レスポンス形式の不統一
  ├─ Front: Options API 残存（約17ファイル）
  └─ Test: Front テスト3件・CI無効 / Back 空 request spec 多数

Medium ───── 品質・体験
  ├─ i18n ハードコード大量残存
  ├─ Google Maps レガシー API
  ├─ a11y / 画像最適化 / Toast メモリリーク
  └─ Fat Controller（SpotsController ~200行）
```

---

## 2. 方針（原則）

1. **壊れているものを先に直す** — 機能不全・認可穴をリファクタより優先
2. **契約を固定してから形を変える** — API の JSON 形を request spec / 型で固定してから統一
3. **縦スライスで進める** — 「ページ1枚 + 対応 API」単位で完了させ、巨大ブランチを避ける
4. **ドキュメントを現状に同期する** — `front/docs/improvements/` の完了マークを実態に合わせる
5. **テストを安全網にする** — リファクタ対象には先に最小の回帰テストを置く

---

## 3. フェーズ計画

> カレンダー日数ではなく、**変更の侵襲度と依存関係**で区切る。  
> 各フェーズは独立 PR に分割可能。

### Phase 0 — 計画・現状同期（本 PR）

| ID | タスク | 成果物 |
|----|--------|--------|
| P0-1 | 本計画書の追加 | `REFACTORING_PLAN.md` |
| P0-2 | 旧改善ドキュメントのステータス注記 | `front/docs/improvements/README.md` 更新 |

**完了条件**: チームが「何が終わっていて、何が次か」を共有できる。

---

### Phase 1 — Critical 修正（機能復旧・セキュリティ）

侵襲度: **中**（バグ修正中心、API 契約は極力維持）

#### Backend

| ID | タスク | 根拠 | 検証 |
|----|--------|------|------|
| P1-B1 | `RelationshipsController` の `active_relationships` → `relationships` に修正 | `user.rb` に `active_relationships` 未定義 | request spec 追加 |
| P1-B2 | `UserPolicy` 追加、`UsersController#update` / `#show` に `authorize` | 任意ユーザー更新が可能 | 403 の request spec |
| P1-B3 | `UsersController#create` 実装、または signup ルートを明示的に閉じる | `routes.rb` は `resources :users`、create 未実装 | signup E2E / request spec |
| P1-B4 | `db:migrate` 後の `schema.rb` に `spot_seasons` を反映 | migrate と schema の乖離 | seasonal API の request spec |
| P1-B5 | `LocationsController#show` の `set_spot` バグ修正 | location ID で Spot を検索している | locations request spec |

#### Frontend

| ID | タスク | 根拠 | 検証 |
|----|--------|------|------|
| P1-F1 | `$axios` / `$auth` 依存ページを Composition API + `$api`/`$fetch` へ移行 | 8〜9 ページが Nuxt 3 で動かない可能性 | 手動確認 + 主要フローの unit/smoke |
| P1-F2 | 優先移行順: `logout` → `favorites` → `newspots` → `account/settings` → `account/userEdit` → `reviews/new` → `location/_id` → `prefecture/_id` → `user/_id` | コア導線から | 各ページの動作確認 |
| P1-F3 | Google Maps を `vue3-google-map` に統一（`spotData.vue`, `newspots.vue`） | `$gmapApiPromiseLazy` / `GmapMap` レガシー | 地図表示確認 |

**完了条件**

- [ ] `$axios` / `$auth` 参照が 0
- [ ] フォロー API が 500 にならない
- [ ] 他ユーザーの `PATCH /users/:id` が 403
- [ ] signup が API と整合
- [ ] `schema.rb` に `spot_seasons` がある

**リスク**: レガシーページ移行時に Cookie / Authorization ヘッダーの付け忘れ。`$api` プラグイン経由に寄せると安全。

---

### Phase 2 — API 契約の安定化

侵襲度: **中〜高**（フロント・バック同時変更が必要になりやすい）

| ID | タスク | 内容 |
|----|--------|------|
| P2-1 | 共通レスポンスヘルパー | Back: `ApiResponse.success/error` で `{ data }` / `{ error }` を統一。段階移行（旧形互換レイヤ可） |
| P2-2 | Front API 層の一本化 | `$api`（`plugins/api.ts`）を正とし、生 `$fetch` と未使用 `useSpotStore` の方針を決定（活用 or 削除） |
| P2-3 | 型と実レスポンスの突合 | `types/api/*` を実 JSON に合わせ、コンポーネントローカル型を集約 |
| P2-4 | Contract test | 壊れやすいエンドポイントに request spec でキー固定（下記「契約ホットスポット」） |
| P2-5 | 認可拡大 | `ReviewPolicy` / `FavoritePolicy` / `LikePolicy` / `RelationshipPolicy` |
| P2-6 | JWT `current_user` で `activated` チェック | 未アクティベートユーザーの排除 |
| P2-7 | Rack::Attack 設定の単一化 | `application.rb` / `rack_attack.rb` / `security_headers.rb` の二重定義解消 |

#### 契約ホットスポット（変更時は Front も同時修正）

| エンドポイント | 依存 Front | 注意 |
|---------------|------------|------|
| `GET /spots/:id` | spot 詳細・reviews・お気に入り | `favuser`, `average_rating`, nested `prefecture` |
| `GET /spots` | spotSearch / store | `{ spots, prefectures, locations, pagination }` |
| `GET /users/user_data` | settings / favorites / mypage | キー構造変更で一括影響 |
| `POST /user_token` | login | 失敗時が空 body（`head :not_found`） |
| `POST/DELETE favorites` | favorite UI | path `:id` が実質無視されている |
| `POST/DELETE relationships` | followBtn | `follow_id` 依存 |
| `GET /locations/:id` | location ページ | ActiveHash の serialize 形状 |

**完了条件**

- [ ] 成功/失敗レスポンスの形がドキュメント化されている
- [ ] Front の API 呼び出し経路が1系統
- [ ] Policy が主要リソースをカバー
- [ ] ホットスポットに contract test がある

---

### Phase 3 — 構造リファクタ（Fat 解消・認証統一）

侵襲度: **高**（挙動維持のまま内部構造変更）

#### Backend

| ID | タスク |
|----|--------|
| P3-B1 | `Spots::IndexService` / `Spots::ShowService` へロジック移譲（SpotsController スリム化） |
| P3-B2 | 一覧用 / 詳細用 Serializer 分離（index から reviews/favorites の過剰 preload 除去） |
| P3-B3 | `UserSerializer` を counter cache 列利用に変更（`.count` 廃止） |
| P3-B4 | `Spot#average_rating` の毎回 aggregate を見直し（キャッシュ or 事前計算） |
| P3-B5 | 未使用 `PrefectureLocationService` の削除 or 採用 |
| P3-B6 | Review の update/destroy を実装するか、routes を `:only` で制限 |

#### Frontend

| ID | タスク |
|----|--------|
| P3-F1 | 認証の単一化: `authStore` を SoT、`useAuth` は薄いラッパーに |
| P3-F2 | 残り Options API（welcome 系・error layout・account.vue 等）を Composition API 化 |
| P3-F3 | 巨大コンポーネント分割: `settings.vue` / `spotData.vue` / `reviews.vue` / `newspots.vue` |
| P3-F4 | `useErrorHandler` + `types/errors.ts` 導入、Toast 連携 |
| P3-F5 | `definePageMeta` + middleware への layout 関数置換完了 |

**完了条件**

- [ ] SpotsController が薄い（ルーティング + 認可 + render）
- [ ] 認証フローが1経路
- [ ] Options API が 0（welcome を含む）

---

### Phase 4 — テスト・品質基盤

侵襲度: **低〜中**（安全網の構築）

| ID | タスク |
|----|--------|
| P4-1 | Front: Vitest coverage 設定、`yarn test:unit` を CI で有効化（現状 `if: false`） |
| P4-2 | Front: stores（auth/spot/toast）・composables（useAuth/useSecureStorage）の unit test |
| P4-3 | Back: 空の request spec を実装（users / relationships / locations / prefectures） |
| P4-4 | Back: Policy spec 追加、SimpleCov 閾値を 40% → 50% → 60% と段階引き上げ |
| P4-5 | Front 改善ドキュメントの Critical/High チェックリストを現状に更新 |

**完了条件**

- [ ] Front CI でテストが走る
- [ ] Back の空 spec が解消
- [ ] カバレッジ閾値が引き上げ済み

---

### Phase 5 — i18n・a11y・パフォーマンス仕上げ

侵襲度: **低〜中**

| ID | タスク |
|----|--------|
| P5-1 | ハードコード文字列のキー化（nav → auth → spot → validation の順） |
| P5-2 | `en.json` を ja とキー同期 |
| P5-3 | ヘッダー・フォームへの ARIA / キーボード操作 |
| P5-4 | `<v-img>` → `OptimizedImage`（約21箇所） |
| P5-5 | Toast の timeout ID 管理（メモリリーク解消） |
| P5-6 | Vuetify tree-shaking、`console` 整理、未使用ファイル削除 |
| P5-7 | 依存更新（Nuxt / ESLint 9 / Vitest 等）は別 PR で段階的に |

---

## 4. 推奨 PR 分割

巨大 PR を避けるための単位:

| PR | 内容 | 依存 |
|----|------|------|
| PR-A | Phase 0（本計画） | なし |
| PR-B | Back Critical（P1-B1〜B5） | なし |
| PR-C | Front `$axios` 除去 前半（logout/favorites/newspots） | PR-B 推奨 |
| PR-D | Front `$axios` 除去 後半 + Maps | PR-C |
| PR-E | API 契約ヘルパー + contract tests | PR-B |
| PR-F | Front API 層統一 + 認証統一 | PR-D, PR-E |
| PR-G | Spots Service 抽出 + Serializer 分離 | PR-E |
| PR-H | テスト CI 有効化 + 空 spec 埋め | PR-B 以降いつでも並行可 |
| PR-I | i18n / a11y / 画像 | PR-F 以降 |

---

## 5. 優先度マトリクス（現状）

```
影響大 │ ①認可穴・relationships   ②$axios/$auth除去
       │    Users#create/schema      Maps統一
       │
影響中 │ ③API契約・認証統一       ④テストCI・空spec
       │    Policy拡大
       │
影響小 │ ⑤i18n/a11y/画像          ⑥依存更新・console整理
       └──────────────────────────────────────────
         緊急度低              緊急度高
```

---

## 6. やらないこと（スコープ外）

意図的に本計画から外すもの:

- UI の全面リデザイン（既存 Vuetify デザインシステムを維持）
- Nuxt 4 / Rails 8 へのメジャーアップグレード（別計画）
- DB エンジン変更（MySQL 5.7 → 8）はインフラ計画として分離
- マイクロサービス分割

---

## 7. 成功指標

| 指標 | 現状（目安） | 目標 |
|------|-------------|------|
| Front `$axios`/`$auth` 参照 | 8〜9 ファイル | 0 |
| Options API ページ | ~11 | 0 |
| Front テストファイル | 3 | stores/composables カバー + CI 有効 |
| Back Policy 対象 | Spot のみ | User/Review/Favorite/Like/Relationship |
| API エラーキー | `error`/`errors` 混在 | 文書化された単一形 |
| `schema.rb` と migrate | `spot_seasons` 乖離 | 一致 |
| SimpleCov | 閾値 40% | 段階的に 60%+ |

---

## 8. 旧ドキュメントとの関係

| ドキュメント | 扱い |
|--------------|------|
| `front/docs/improvements/00〜05` | **参考アーカイブ**。Critical の多くは完了済み。ステータスは本計画を正とする |
| `NUXT3_UPGRADE_*.md` | アップグレード完了の記録。残課題は本計画 Phase 1〜3 に吸収 |
| `PERFORMANCE_OPTIMIZATION_SUMMARY.md` | 実施済み最適化の記録。追加分は Phase 3/5 |

---

## 9. 次のアクション

1. 本計画のレビュー・優先順位の合意
2. **PR-B（Backend Critical）** から着手（機能障害・認可が最優先）
3. 並行して **PR-C（Front レガシー API 除去）** を開始
4. 各 PR マージ後に本ファイルのチェックリストを更新

---

**最終更新**: 2026-07-08
