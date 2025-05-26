require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application

    # Cookieを処理するmeddlewareを追加(APIモードにはデフォルトで入っていない)
    config.middleware.use ActionDispatch::Cookies

    config.api_only = true
    
    # Zeitwerk（ツァイトベルク）にvalidator配下のファイルを読み込ます
    config.autoload_paths += %W(#{config.root}/lib/validator)
    config.autoload_paths += %W(#{config.root}/app/validators)
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Railsアプリデフォルトのタイムゾーン(default 'UTC')
    # TimeZoneList: http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html
    config.time_zone = ENV["TZ"] || 'Asia/Tokyo'

    # データベースの読み書きに使用するタイムゾーン(:local | :utc(default))
    config.active_record.default_timezone = :utc

    # i18nで使われるデフォルトのロケールファイルの指定(default :en)
    config.i18n.default_locale = :ja

    # $LOAD_PATHにautoload pathを追加しない(Zeitwerk有効時false推奨)
    config.add_autoload_paths_to_load_path = false

    # キャッシュストアの設定
    config.cache_store = :memory_store, { size: 64.megabytes }

    # セキュリティヘッダーの設定
    config.force_ssl = Rails.env.production?
    
    # CORS設定
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV['FRONTEND_URL'] || 'http://localhost:3000'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end
  end
end
