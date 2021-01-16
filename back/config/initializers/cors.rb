Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'https://www.nature-spots.work' || ""
    origins 'http://localhost:8080' || ""

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      # クロスオリジンのCookieを使用するための設定
      credentials: true
  end
end
