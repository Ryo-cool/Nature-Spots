# Nature-Spots
自然スポットの口コミサイトです。<br >
旅行先の景色や好きな自然スポットを位置情報付きで共有できます。<br >
レスポンシブ対応<br >
<img width="733" alt="スクショ2020-10-16 19 16 10" src="https://user-images.githubusercontent.com/58380104/96246943-5b151300-0fe4-11eb-9435-bc4d0c88971e.png">
<h2 align="left">Frontend</h2>

<p align="left">
  <a href="https://jp.vuejs.org/index.html"><img src="https://user-images.githubusercontent.com/39142850/71645835-a98d4580-2d21-11ea-9693-348d12101bb4.png" width="80px;" /></a>
  <a>　</a>
  <a href="https://ja.nuxtjs.org/guide/"><img src="https://user-images.githubusercontent.com/59280290/80292478-f645d200-8791-11ea-9a0b-57ec5a7ec487.png" height="80px" /></a>
<a>　</a>
</p>

<h2 align="left">Backend</h2>
<p align="left">
<a>　</a>
  <a href="https://rubyonrails.org/"><img src="https://user-images.githubusercontent.com/59280290/80292396-7a4b8a00-8791-11ea-8d8a-effea8a1f485.png" height="45px;" /></a>
<a>　</a>
  <a href="https://aws.amazon.com/jp/?nc2=h_lg"><img src="https://user-images.githubusercontent.com/59280290/80302130-2ec1cc00-87e3-11ea-813c-dcdb51a02af5.png" height="45px;" /></a>
<a>　</a>
  <a href="https://www.mysql.com/jp/"><img src="https://user-images.githubusercontent.com/59280290/80302176-6cbef000-87e3-11ea-9643-1f4b446dfaa8.png" height="45px;" /></a>
    <a href="https://circleci.com/ja/"><img src="https://user-images.githubusercontent.com/58380104/104709632-85e94180-5762-11eb-8ccc-c3bc2d0f1be1.jpg" height="45px;" /></a>


# URL
https://www.nature-spots.work/  （現在停止中)

# 使用技術
- フロント
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
  - CircleCI(CI/CD)
  - AWS (VPC,ECS,ECR,RDS,Route53,ELB,ACM,IAM)
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

# インフラ構成図
<img width="704" alt="スクリーンショット 2020-12-08 18 28 33" src="https://user-images.githubusercontent.com/58380104/101465370-35244300-3983-11eb-810a-31062e02577e.png">


