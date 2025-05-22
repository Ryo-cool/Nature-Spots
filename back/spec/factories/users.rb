FactoryBot.define do
  factory :user do
    name { "試験太郎" } # Valid Japanese name
    sequence(:email) { |n| "testuser#{n}@example.com" } # Unique email
    password { "ValidPass123" } # Password that meets complexity requirements
    password_confirmation { "ValidPass123" }
  end
end