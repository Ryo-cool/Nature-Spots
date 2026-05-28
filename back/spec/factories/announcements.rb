FactoryBot.define do
  factory :announcement do
    title { "メンテナンスのお知らせ" }
    body { "本日深夜にメンテナンスを実施します。ご了承ください。" }
    published_at { Time.current }
    association :author, factory: :user

    trait :draft do
      published_at { nil }
    end
  end
end
