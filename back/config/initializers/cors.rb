Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # 環境に応じたオリジン設定
    allowed_origins = if Rails.env.production?
                        ['https://www.nature-spots.work', 'https://nature-spots.work']
                      else
                        ['http://localhost:8080', 'http://localhost:3000', 'http://127.0.0.1:8080']
                      end

    origins allowed_origins

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      # クロスオリジンのCookieを使用するための設定
      credentials: true
  end
end
