FactoryBot.define do
  factory :favorite do
    association :user
    association :spot
  end
end
