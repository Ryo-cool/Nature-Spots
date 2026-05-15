FactoryBot.define do
  factory :spot do
    name { "Test Spot" }
    address { "1-1-1 Test, Shibuya, Tokyo" }
    introduction { "Test spot description." }
    prefecture_id { 13 } # Tokyo
    location_id { 1 }
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    association :user

    trait :with_reviews do
      after(:create) do |spot|
        create_list(:review, 3, spot: spot)
      end
    end

    trait :with_season do
      transient do
        season_id { 1 }
      end

      after(:create) do |spot, evaluator|
        spot.spot_seasons.create!(season_id: evaluator.season_id)
      end
    end
  end
end
