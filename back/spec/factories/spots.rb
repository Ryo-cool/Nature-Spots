FactoryBot.define do
  factory :spot do
    association :user
    sequence(:name) { |n| "テストスポット#{n}" }
    introduction { "テスト用のスポット説明文です。" }
    address { "東京都渋谷区テスト1-1-1" }
    prefecture_id { 1 }
    location_id { 1 }
    longitude { 139.7016358 }
    latitude { 35.6585805 }
    
    trait :with_photo do
      photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    end

    trait :with_reviews do
      after(:create) do |spot|
        create_list(:review, 3, spot: spot)
      end
    end
  end
end
