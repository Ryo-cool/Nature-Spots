FactoryBot.define do
  factory :relationship do
    user
    follow { create(:user) }
  end
end
