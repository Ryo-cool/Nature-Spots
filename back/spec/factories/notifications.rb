FactoryBot.define do
  factory :notification do
    association :recipient, factory: :user
    association :actor, factory: :user
    action { :followed }
    notifiable { nil }

    trait :review_posted do
      action { :review_posted }
      association :notifiable, factory: :review
    end

    trait :followed do
      action { :followed }
      association :notifiable, factory: :relationship
    end

    trait :announcement do
      action { :announcement }
      actor { nil }
      association :notifiable, factory: :announcement
    end

    trait :read do
      read_at { Time.current }
    end
  end
end
