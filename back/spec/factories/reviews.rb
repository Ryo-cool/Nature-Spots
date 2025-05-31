FactoryBot.define do
  factory :review do
    title { "素晴らしいスポット" }
    content { "とても良いスポットでした。自然が豊かで癒されました。" }
    rating { 4 }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    association :user
    association :spot

    trait :excellent do
      title { "最高のスポット" }
      rating { 5 }
      content { "最高のスポットです！絶対にまた来たいと思います。" }
    end

    trait :poor do
      title { "期待外れ" }
      rating { 2 }
      content { "期待していたほどではありませんでした。" }
    end
  end
end
