require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user_params) { { name: "田中太郎", email: "test@example.com", password: "Password123", password_confirmation: "Password123" } }

    it 'is valid with valid attributes' do
      user = User.new(user_params)
      expect(user).to be_valid
    end

    context 'presence' do
      it 'is invalid without a name' do
        user = User.new(user_params.except(:name))
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("を入力してください") # "can't be blank" in Japanese
      end

      it 'is invalid without an email' do
        user = User.new(user_params.except(:email))
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("を入力してください") # "can't be blank" in Japanese
      end
    end

    context 'uniqueness' do
      before do
        User.create!(user_params)
      end

      it 'is invalid with a duplicate email' do
        user = User.new(user_params)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("はすでに存在します") # "has already been taken" in Japanese
      end
    end

    context 'format' do
      context 'email' do
        it 'is invalid with an invalid email format' do
          invalid_emails = %w(user@example,com user_at_example.org user.example.com @example.com example.com)
          invalid_emails.each do |invalid_email|
            user = User.new(user_params.merge(email: invalid_email))
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include("は不正な値です") # "is invalid" in Japanese
          end
        end

        it 'is valid with a valid email format' do
          valid_emails = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
          valid_emails.each do |valid_email|
            user = User.new(user_params.merge(email: valid_email))
            # The password validation might fail if not provided, let's ensure it's valid or skip if not needed for this specific test
            # For simplicity, assuming other validations pass or are not the focus here.
            # If password presence is an issue, we might need to set it: user.password = 'Password123'; user.password_confirmation = 'Password123'
            expect(user).to be_valid # This might fail if other validations (like password) are not met.
                                     # Let's refine this to focus only on email if necessary,
                                     # or ensure all other attributes are valid.
                                     # For now, assuming user_params provides a valid base.
          end
        end
      end
    end
  end
end