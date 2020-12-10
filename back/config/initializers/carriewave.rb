
# require_relative "constants"
CarrierWave.configure do |config|
  # config.asset_host = Constants::URL
  config.asset_host = "http://localhost:3000/"
end