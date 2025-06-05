FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "Password123" }
    password_confirmation { "Password123" }
    introduction { "Test user introduction." }
    activated { true }

    trait :with_image do
      # 画像ファイルのテスト用設定
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    end

    trait :inactive do
      activated { false }
    end
  end
end