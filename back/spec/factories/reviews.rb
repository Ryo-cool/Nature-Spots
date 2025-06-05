FactoryBot.define do
  factory :review do
    title { "Amazing Spot" }
    text { "This was a wonderful spot. Nature was abundant and very relaxing." }
    rating { 4 }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    association :user
    association :spot

    trait :excellent do
      title { "Best Spot Ever" }
      rating { 5 }
      text { "This is the best spot! I definitely want to come back again." }
    end

    trait :poor do
      title { "Disappointing" }
      rating { 2 }
      text { "It wasn't as expected." }
    end
  end
end
