
require_relative "constants"
CarrierWave.configure do |config|
  config.asset_host = Constants::URL
end