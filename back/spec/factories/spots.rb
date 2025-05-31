FactoryBot.define do
  factory :spot do
    name { "テストスポット" }
    address { "東京都渋谷区テスト1-1-1" }
    introduction { "テスト用のスポット説明文です。" }
    prefecture_id { 13 } # 東京都
    location_id { 1 }
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    association :user

    trait :with_reviews do
      after(:create) do |spot|
        create_list(:review, 3, spot: spot)
      end
    end
  end
end
