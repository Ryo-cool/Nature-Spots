# 実装ロードマップ

📅 **段階的な改善計画**

このドキュメントでは、フロントエンドの改善を段階的に実装するための具体的なロードマップを提示します。

---

## 📋 目次

1. [全体スケジュール](#全体スケジュール)
2. [フェーズ1: 基盤整備](#フェーズ1-基盤整備-2-3週間)
3. [フェーズ2: リファクタリング](#フェーズ2-リファクタリング-3-4週間)
4. [フェーズ3: 機能改善](#フェーズ3-機能改善-2-3週間)
5. [フェーズ4: テスト・最適化](#フェーズ4-テスト最適化-2-3週間)
6. [継続的改善](#継続的改善)

---

## 全体スケジュール

```
┌─────────────────────────────────────────────────────────────┐
│                    全体スケジュール (12週間)                  │
├─────────────────────────────────────────────────────────────┤
│ フェーズ1: 基盤整備          │ 週1-3   │ Critical対応     │
│ フェーズ2: リファクタリング   │ 週4-7   │ High対応         │
│ フェーズ3: 機能改善          │ 週8-10  │ Medium対応       │
│ フェーズ4: テスト・最適化    │ 週11-12 │ 品質保証         │
└─────────────────────────────────────────────────────────────┘
```

### マイルストーン

| #   | マイルストーン               | 完了予定 | 成功基準                    |
| --- | ---------------------------- | -------- | --------------------------- |
| M1  | セキュリティ修正完了         | 週2終了  | 機密情報のハードコードが0件 |
| M2  | TypeScript strict mode有効化 | 週3終了  | any型が0件、strict: true    |
| M3  | Composition API統一          | 週5終了  | Options APIが0件            |
| M4  | API移行完了                  | 週6終了  | $axiosが0件                 |
| M5  | テストカバレッジ達成         | 週10終了 | カバレッジ80%以上           |
| M6  | 全改善完了                   | 週12終了 | すべてのチェックリスト完了  |

---

## フェーズ1: 基盤整備 (2-3週間)

### 🎯 目標

セキュリティリスクの排除と型安全性の基盤を構築する

### 📅 スケジュール

#### 週1: セキュリティ修正

| 日  | タスク                 | 担当 | 成果物                   |
| --- | ---------------------- | ---- | ------------------------ |
| 1   | 認証情報の環境変数化   | -    | .env.example更新         |
| 2   | 暗号化キーの必須化     | -    | nuxt.config.ts修正       |
| 3   | 入力バリデーション強化 | -    | useValidation composable |
| 4   | Storage Composable作成 | -    | useSecureStorage.ts      |
| 5   | セキュリティテスト     | -    | テスト結果レポート       |

**成果物**:

- [ ] `.env.example`に必要な環境変数を記載
- [ ] `nuxt.config.ts`でCRYPTO_KEYを必須化
- [ ] `composables/useValidation.ts`作成
- [ ] `composables/useSecureStorage.ts`作成
- [ ] セキュリティチェックリスト完了

#### 週2: TypeScript strict mode 段階1

| 日  | タスク                                   | 担当 | 成果物          |
| --- | ---------------------------------------- | ---- | --------------- |
| 1-2 | tsconfig.json修正（noImplicitAny有効化） | -    | tsconfig.json   |
| 3-5 | エラー型定義の整備                       | -    | types/errors.ts |
| 3-5 | any型の修正（stores）                    | -    | 修正済みstore   |

**成果物**:

- [ ] `tsconfig.json`の`noImplicitAny: true`
- [ ] `types/errors.ts`完成
- [ ] stores/内のany型が0件

#### 週3: TypeScript strict mode 段階2 + Signup実装

| 日  | タスク                             | 担当 | 成果物           |
| --- | ---------------------------------- | ---- | ---------------- |
| 1-2 | any型の修正（composables/plugins） | -    | 修正済みファイル |
| 3-4 | Signup機能実装                     | -    | 動作するSignup   |
| 5   | strict: true有効化                 | -    | 完全strict mode  |

**成果物**:

- [ ] プロジェクト全体でany型が0件
- [ ] Signupページが動作
- [ ] `tsconfig.json`の`strict: true`

### 🎯 フェーズ1完了基準

- [x] セキュリティ問題が0件
- [x] TypeScript strict mode有効
- [x] any型が0件
- [x] Signup機能が動作
- [x] すべてのCritical課題が解決

---

## フェーズ2: リファクタリング (3-4週間)

### 🎯 目標

コードベースを最新のベストプラクティスに準拠させる

### 📅 スケジュール

#### 週4: Composition API移行 開始

| 日  | タスク             | 担当 | 成果物            |
| --- | ------------------ | ---- | ----------------- |
| 1   | signup.vue移行     | -    | Composition API版 |
| 2   | login.vue移行      | -    | Composition API版 |
| 3   | logout.vue移行     | -    | Composition API版 |
| 4   | index.vue移行      | -    | Composition API版 |
| 5   | レビューと動作確認 | -    | テスト完了        |

**成果物**:

- [ ] 認証関連ページがComposition API化
- [ ] 各ページの動作確認完了

#### 週5: Composition API移行 継続

| 日  | タスク                   | 担当 | 成果物                |
| --- | ------------------------ | ---- | --------------------- |
| 1-2 | newspots.vue移行（複雑） | -    | Composition API版     |
| 3   | spots/\_id/index.vue移行 | -    | Composition API版     |
| 4-5 | その他8ファイル移行      | -    | すべてComposition API |

**成果物**:

- [ ] すべてのページがComposition API化
- [ ] Options APIが0件

#### 週6: $axios → $fetch 移行

| 日  | タスク             | 担当 | 成果物              |
| --- | ------------------ | ---- | ------------------- |
| 1   | APIプラグイン作成  | -    | plugins/api.ts      |
| 2-3 | 主要ファイルの移行 | -    | useFetch使用        |
| 4   | 残りファイルの移行 | -    | $axios完全削除      |
| 5   | テストと動作確認   | -    | すべてのAPI動作確認 |

**成果物**:

- [ ] `plugins/api.ts`作成
- [ ] $axiosが0箇所
- [ ] すべてのAPI呼び出しが動作

#### 週7: エラーハンドリング統一

| 日  | タスク                   | 担当 | 成果物               |
| --- | ------------------------ | ---- | -------------------- |
| 1   | エラー型定義完成         | -    | types/errors.ts      |
| 2   | useErrorHandler作成      | -    | composables/         |
| 3-4 | 既存コードへの適用       | -    | 統一されたエラー処理 |
| 5   | エラーハンドリングテスト | -    | テスト完了           |

**成果物**:

- [ ] `composables/useErrorHandler.ts`完成
- [ ] エラーハンドリングが統一
- [ ] エラー表示が一貫

### 🎯 フェーズ2完了基準

- [x] Options APIが0件
- [x] $axiosが0件
- [x] エラーハンドリングが統一
- [x] すべてのHigh課題が解決

---

## フェーズ3: 機能改善 (2-3週間)

### 🎯 目標

品質向上とユーザー体験の改善

### 📅 スケジュール

#### 週8: i18n完全実装

| 日  | タスク             | 担当 | 成果物               |
| --- | ------------------ | ---- | -------------------- |
| 1   | 翻訳キーの洗い出し | -    | 翻訳リスト           |
| 2-3 | ja.json完成        | -    | locales/ja.json      |
| 3-4 | en.json完成        | -    | locales/en.json      |
| 5   | 言語切り替えUI作成 | -    | LanguageSwitcher.vue |

**成果物**:

- [ ] `locales/ja.json`完成（全キー）
- [ ] `locales/en.json`完成（全キー）
- [ ] `LanguageSwitcher.vue`作成

#### 週9: i18n適用 + Props/Emits型定義

| 日  | タスク                      | 担当 | 成果物              |
| --- | --------------------------- | ---- | ------------------- |
| 1-2 | コンポーネントのi18n適用    | -    | ハードコード0件     |
| 3   | 型定義ファイル作成          | -    | types/components.ts |
| 4-5 | フォーム系Props/Emits型定義 | -    | 型定義完了          |

**成果物**:

- [ ] ハードコードされた文字列が0件
- [ ] `types/components.ts`完成
- [ ] フォーム系の型定義完了

#### 週10: メモリリーク対策 + 画像最適化

| 日  | タスク                       | 担当 | 成果物               |
| --- | ---------------------------- | ---- | -------------------- |
| 1   | Toast Store修正              | -    | メモリリーク解消     |
| 2   | その他メモリリーク調査・修正 | -    | 全箇所対策           |
| 3   | OptimizedImage改善           | -    | 改善版コンポーネント |
| 4-5 | 画像最適化の全面適用         | -    | すべて最適化済み     |

**成果物**:

- [ ] メモリリークが0件
- [ ] すべての画像が最適化済み
- [ ] OptimizedImageが全箇所で使用

### 🎯 フェーズ3完了基準

- [x] i18n完全実装
- [x] Props/Emits型定義完了
- [x] メモリリーク対策完了
- [x] 画像最適化完了
- [x] すべてのMedium課題が解決

---

## フェーズ4: テスト・最適化 (2-3週間)

### 🎯 目標

品質保証とパフォーマンス最適化

### 📅 スケジュール

#### 週11: テスト実装

| 日  | タスク                 | 担当 | 成果物           |
| --- | ---------------------- | ---- | ---------------- |
| 1   | Vitest環境セットアップ | -    | vitest.config.ts |
| 2   | Storeテスト作成        | -    | カバレッジ20%    |
| 3   | Composableテスト作成   | -    | カバレッジ40%    |
| 4-5 | Componentテスト作成    | -    | カバレッジ60%    |

**成果物**:

- [ ] テスト環境構築完了
- [ ] Storeテスト完了
- [ ] Composableテスト完了
- [ ] カバレッジ60%達成

#### 週12: テスト完成 + 最適化 + アクセシビリティ

| 日  | タスク               | 担当 | 成果物             |
| --- | -------------------- | ---- | ------------------ |
| 1-2 | 残りのテスト作成     | -    | カバレッジ80%      |
| 3   | アクセシビリティ対応 | -    | ARIA属性追加       |
| 4   | コード分割最適化     | -    | バンドルサイズ削減 |
| 5   | 最終レビュー         | -    | すべて完了         |

**成果物**:

- [ ] カバレッジ80%達成
- [ ] WCAG 2.1 AA準拠
- [ ] バンドルサイズ最適化
- [ ] すべての改善項目完了

### 🎯 フェーズ4完了基準

- [x] テストカバレッジ80%以上
- [x] アクセシビリティ対応完了
- [x] パフォーマンス最適化完了
- [x] すべての課題が解決

---

## 継続的改善

### 📊 品質メトリクス

実装後も以下のメトリクスを継続的に監視：

| メトリクス               | 目標値    | 測定方法               |
| ------------------------ | --------- | ---------------------- |
| TypeScript strictness    | 100%      | `tsc --noEmit`         |
| テストカバレッジ         | 80%以上   | `vitest --coverage`    |
| Lighthouse Performance   | 90点以上  | Lighthouse CI          |
| Lighthouse Accessibility | 95点以上  | Lighthouse CI          |
| バンドルサイズ           | 250KB以下 | `yarn build --analyze` |
| ビルド時間               | 30秒以内  | CI/CDログ              |

### 🔄 定期レビュー

#### 毎週

- [ ] テストカバレッジの確認
- [ ] 新規追加されたTODOの確認
- [ ] TypeScriptエラーの確認

#### 毎月

- [ ] Lighthouse スコアの測定
- [ ] 依存パッケージの更新確認
- [ ] セキュリティ監査（`yarn audit`）
- [ ] バンドルサイズの確認

#### 四半期ごと

- [ ] アーキテクチャレビュー
- [ ] パフォーマンス最適化の検討
- [ ] 技術的負債の評価
- [ ] 改善計画の見直し

### 🛠️ 自動化

#### GitHub Actions

```yaml
# .github/workflows/quality-check.yml
name: Quality Check

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: "18"

      - name: Install dependencies
        run: cd front && yarn install

      - name: Type check
        run: cd front && yarn type-check

      - name: Lint
        run: cd front && yarn lint

      - name: Test
        run: cd front && yarn test:coverage

      - name: Build
        run: cd front && yarn build

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./front/coverage/coverage-final.json
```

#### Pre-commit hooks

```bash
# front/.husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

cd front

# Type check
yarn type-check

# Lint
yarn lint

# Test
yarn test --run
```

---

## 📋 最終チェックリスト

### セキュリティ

- [ ] 機密情報のハードコードが0件
- [ ] 環境変数が適切に設定
- [ ] 入力バリデーションが全箇所で実装
- [ ] セキュリティヘッダーが設定

### 型安全性

- [ ] TypeScript strict mode有効
- [ ] any型が0件
- [ ] Props/Emitsがすべて型定義済み
- [ ] 型エラーが0件

### コード品質

- [ ] Options APIが0件（Composition API統一）
- [ ] $axiosが0件（$fetch/useFetch使用）
- [ ] エラーハンドリングが統一
- [ ] Console.logが整理済み

### テスト

- [ ] テストカバレッジ80%以上
- [ ] すべての重要機能にテストあり
- [ ] CIでテストが自動実行

### パフォーマンス

- [ ] 画像が最適化済み
- [ ] コード分割が適切
- [ ] メモリリークが0件
- [ ] Lighthouse Performance 90点以上

### アクセシビリティ

- [ ] ARIA属性が適切に設定
- [ ] キーボード操作が可能
- [ ] WCAG 2.1 AA準拠
- [ ] Lighthouse Accessibility 95点以上

### 国際化

- [ ] ハードコード文字列が0件
- [ ] 日本語翻訳完了
- [ ] 英語翻訳完了
- [ ] 言語切り替えが動作

### その他

- [ ] 未使用ファイルが0件
- [ ] TODOコメントが0件（またはIssue化）
- [ ] ドキュメントが最新

---

## 🎉 完了後の期待される状態

### コード品質

- ✅ 型安全で保守しやすいコードベース
- ✅ 一貫したコーディングスタイル
- ✅ 高いテストカバレッジ

### ユーザー体験

- ✅ 高速な読み込み時間
- ✅ アクセシブルなUI
- ✅ 多言語対応

### 開発者体験

- ✅ 正確なIDE補完
- ✅ 安全なリファクタリング
- ✅ 明確なエラーメッセージ

### セキュリティ

- ✅ OWASP Top 10対策済み
- ✅ 適切な認証・認可
- ✅ 安全なデータ管理

---

## 📚 参考リソース

### 公式ドキュメント

- [Nuxt 3 Documentation](https://nuxt.com/docs)
- [Vue 3 Documentation](https://vuejs.org/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Vitest Documentation](https://vitest.dev/)

### ベストプラクティス

- [Vue.js Best Practices](https://vuejs.org/guide/best-practices/)
- [TypeScript Best Practices](https://typescript-tv.github.io/typescript-tips/)
- [Web Accessibility Guidelines (WCAG 2.1)](https://www.w3.org/WAI/WCAG21/quickref/)

### ツール

- [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- [Vue Devtools](https://devtools.vuejs.org/)
- [TypeScript Playground](https://www.typescriptlang.org/play)

---

## 💬 サポート

質問や問題が発生した場合：

1. このドキュメント群を参照
2. プロジェクトの開発チームに相談
3. 各技術の公式ドキュメントを確認

---

**最終更新**: 2025-11-22
**次回レビュー予定**: 実装開始後1ヶ月
