FactoryBot.define do
  factory :review do
    title { "素晴らしいスポット" }
    text { "とても良いスポットでした。自然が豊かで癒されました。" }
    rating { 4 }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
    association :user
    association :spot

    trait :excellent do
      title { "最高のスポット" }
      rating { 5 }
      text { "最高のスポットです！絶対にまた来たいと思います。" }
    end

    trait :poor do
      title { "期待外れ" }
      rating { 2 }
      text { "期待していたほどではありませんでした。" }
    end
  end
end
