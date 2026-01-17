# frozen_string_literal: true

# Rack::Attack Configuration
# DDoS/Brute-force protection for API endpoints

class Rack::Attack
  # Use Rails.cache as the backend cache store
  Rack::Attack.cache.store = Rails.cache

  # Throttle login attempts by IP address
  # 5 requests per 20 seconds
  throttle("login/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/api/v1/user_token" && req.post?
  end

  # Throttle user registration by IP address
  # 3 requests per minute
  throttle("signup/ip", limit: 3, period: 1.minute) do |req|
    req.ip if req.path == "/api/v1/users" && req.post?
  end

  # General API rate limiting by IP address
  # 300 requests per 5 minutes
  throttle("api/ip", limit: 300, period: 5.minutes) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |env|
    retry_after = (env["rack.attack.match_data"] || {})[:period]
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [{ error: "Rate limit exceeded. Please try again later." }.to_json]
    ]
  end
end
