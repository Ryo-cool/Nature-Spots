FactoryBot.define do
  factory :relationship do
    association :user
    association :follow, factory: :user
  end
end
