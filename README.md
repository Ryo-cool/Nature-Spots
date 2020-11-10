# Nature-Spots
自然スポットの口コミサイトです。<br >
旅行先の景色や好きな自然スポットを位置情報付きで共有できます。<br >
レスポンシブ対応しているのでスマホからもご確認いただけます
<img width="733" alt="スクショ2020-10-16 19 16 10" src="https://user-images.githubusercontent.com/58380104/96246943-5b151300-0fe4-11eb-9435-bc4d0c88971e.png">
# URL


# 使用技術
- フロントエンド
  - Nuxt.js(SPA化)
  - vuetify
- バックエンド
  - Ruby 2.6.3
  - Ruby on Rails 6.0.3
- データベース
  - MySQL 5.7
- その他
  - Docker/Docker-compose
  - axios(APIとのHTTP通信),cors(異なるオリジンの許可）
  - nuxt-i18n（国際化対応)
  - bcrypt(パスワード暗号化）
# 機能一覧
- ユーザー登録、ログイン機能(JWT)
- スポット投稿機能
  - 位置情報登録(GoogleApi)
- 口コミ投稿機能
  - 画像投稿(carrierwave)
## 実装予定
- いいね機能
- お気に入り機能（行きたいスポットリスト）
- 通知機能
- 検索機能

**その他使用したライブラリ**
- moment.js(日付フォーマット)
- active_hash
# テスト
- RSpec,FactoryBot
  - 単体テスト(model)
  - 機能テスト(request)
  - 統合テスト(feature)
