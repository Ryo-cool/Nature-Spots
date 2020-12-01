# Nature-Spots
自然スポットの口コミサイトです。<br >
旅行先の景色や好きな自然スポットを位置情報付きで共有できます。<br >
レスポンシブ対応<br >
<img width="733" alt="スクショ2020-10-16 19 16 10" src="https://user-images.githubusercontent.com/58380104/96246943-5b151300-0fe4-11eb-9435-bc4d0c88971e.png">
# URL


# 使用技術
- フロントエンド
  - Vue.js
  - Nuxt.js(SPA化)
  - vuetify
- バックエンド
  - Ruby 2.6.3
  - Ruby on Rails 6.0.3
- データベース
  - MySQL 5.7
- その他
  - Docker/Docker-compose
  - CircleCI(自動テスト・自動ビルド）
  - axios(APIとのHTTP通信),cors(異なるオリジンの許可）
  - nuxt-i18n（国際化対応)
  - bcrypt(パスワード暗号化）
# 機能一覧
- ユーザー登録、ログイン機能(JWT)
  - Cookieにてログイン維持
  - ゲストログイン機能
- ユーザーフォロー機能
- 詳細ページ
  - 投稿、いいねした投稿、フォロー＆フォロワー表示
- スポット投稿機能
  - スポット名入力でGoogle MAP緯度経度取得(Geocording API)
- 一覧画面
  - 都道府県別リンク
  - ジャンル別リンク
  - レビュー数順スポット
- 詳細ページ
  - Google MAP表示（Google Maps Javascript API）
 - 検索機能
  - オートコンプリート機能
- 口コミ投稿機能
  - 画像投稿(carrierwave)
  - いいね機能
- お気に入り機能
  - お気に入り登録・削除
  - お気に入り一覧表示

**その他使用したライブラリ**
- moment.js(日付フォーマット)
- active_hash
# テスト
- RSpec,FactoryBot
  - 単体テスト(model)
  - 機能テスト(request)
  - 統合テスト(feature)

# ER図
<img width="915" alt="スクリーンショット 2020-11-23 17 04 53" src="https://user-images.githubusercontent.com/58380104/99939743-21d37e00-2dae-11eb-8ec8-aee6c6f0d63b.png">

