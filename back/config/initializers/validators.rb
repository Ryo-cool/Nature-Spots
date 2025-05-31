# カスタムバリデーターの読み込み
Dir[Rails.root.join('app', 'validators', '*.rb')].each { |f| require f }
Dir[Rails.root.join('lib', 'validator', '*.rb')].each { |f| require f } 