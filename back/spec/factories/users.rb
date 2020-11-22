FactoryBot.define do
  factory :user do
    name { 'testuser' }
    email { 'kkk@gmail.com"'}
    password_digest { "00000000" }
  end
end