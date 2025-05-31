# セキュリティヘッダーの設定
Rails.application.config.middleware.use(Rack::Attack) if Rails.env.production?

# セキュリティヘッダーの設定
Rails.application.config.middleware.insert_before(
  ActionDispatch::Static,
  Rack::Attack
) if Rails.env.production?

# セキュリティヘッダーの追加
Rails.application.config.middleware.insert_after(
  ActionDispatch::Static,
  Proc.new do |app|
    Proc.new do |env|
      status, headers, response = app.call(env)
      
      # セキュリティヘッダーの設定
      headers['X-Frame-Options'] = 'DENY'
      headers['X-Content-Type-Options'] = 'nosniff'
      headers['X-XSS-Protection'] = '1; mode=block'
      headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
      
      # HSTS（本番環境のみ）
      if Rails.env.production?
        headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains; preload'
      end
      
      # CSP（Content Security Policy）
      csp_directives = [
        "default-src 'self'",
        "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://maps.googleapis.com https://maps.gstatic.com",
        "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://maps.googleapis.com",
        "font-src 'self' https://fonts.gstatic.com",
        "img-src 'self' data: https: blob:",
        "connect-src 'self' https://maps.googleapis.com",
        "frame-src 'none'",
        "object-src 'none'",
        "base-uri 'self'"
      ]
      
      headers['Content-Security-Policy'] = csp_directives.join('; ')
      
      [status, headers, response]
    end
  end
)

# Rack::Attack の設定（本番環境のみ）
if Rails.env.production?
  class Rack::Attack
    # リクエスト制限の設定
    throttle('requests by ip', limit: 300, period: 5.minutes) do |request|
      request.ip
    end
    
    # ログイン試行の制限
    throttle('login attempts by ip', limit: 5, period: 20.seconds) do |request|
      if request.path == '/api/v1/user_token' && request.post?
        request.ip
      end
    end
    
    # API呼び出しの制限
    throttle('api calls by ip', limit: 100, period: 1.minute) do |request|
      if request.path.start_with?('/api/')
        request.ip
      end
    end
    
    # ブロックされたリクエストのログ
    blocklist('block bad actors') do |request|
      # 悪意のあるIPアドレスをブロック（必要に応じて設定）
      false
    end
    
    # カスタムレスポンス
    self.blocklisted_response = lambda do |env|
      [429, {'Content-Type' => 'application/json'}, [{ error: 'Too Many Requests' }.to_json]]
    end
    
    self.throttled_response = lambda do |env|
      [429, {'Content-Type' => 'application/json'}, [{ error: 'Rate Limit Exceeded' }.to_json]]
    end
  end
end 