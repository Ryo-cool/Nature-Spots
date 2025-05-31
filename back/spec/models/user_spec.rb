require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:valid_user) { build(:user) }

    it '有効なユーザーが作成できること' do
      expect(valid_user).to be_valid
    end

    describe 'name' do
      it '名前が必須であること' do
        valid_user.name = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:name]).to include("を入力してください")
      end

      it '名前が2文字以上であること' do
        valid_user.name = 'あ'
        expect(valid_user).not_to be_valid
      end

      it '名前が30文字以下であること' do
        valid_user.name = 'あ' * 31
        expect(valid_user).not_to be_valid
      end

      it '日本語の名前が有効であること' do
        valid_user.name = 'テストユーザー'
        expect(valid_user).to be_valid
      end
    end

    describe 'email' do
      it 'メールアドレスが必須であること' do
        valid_user.email = nil
        expect(valid_user).not_to be_valid
      end

      it '有効なメールアドレス形式であること' do
        valid_user.email = 'test@example.com'
        expect(valid_user).to be_valid
      end

      it '無効なメールアドレス形式は無効であること' do
        valid_user.email = 'invalid-email'
        expect(valid_user).not_to be_valid
      end

      it 'メールアドレスが一意であること' do
        create(:user, email: 'test@example.com')
        valid_user.email = 'test@example.com'
        expect(valid_user).not_to be_valid
      end
    end

    describe 'password' do
      it 'パスワードが必須であること（新規作成時）' do
        user = build(:user, password: nil)
        expect(user).not_to be_valid
      end

      it '8文字以上のパスワードが有効であること' do
        valid_user.password = 'Password123'
        expect(valid_user).to be_valid
      end

      it '7文字以下のパスワードは無効であること' do
        valid_user.password = 'Pass123'
        expect(valid_user).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many(:spots) }
    it { should have_many(:reviews) }
    it { should have_many(:favorites) }
    it { should have_many(:likes) }
    it { should have_many(:relationships) }
    it { should have_many(:followings) }
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe '#follow' do
      it '他のユーザーをフォローできること' do
        expect { user.follow(other_user) }.to change { user.followings.count }.by(1)
      end

      it '自分自身はフォローできないこと' do
        expect { user.follow(user) }.not_to change { user.followings.count }
      end
    end

    describe '#unfollow' do
      before { user.follow(other_user) }

      it 'フォローを解除できること' do
        expect { user.unfollow(other_user) }.to change { user.followings.count }.by(-1)
      end
    end

    describe '#following?' do
      it 'フォロー状態を正しく判定できること' do
        expect(user.following?(other_user)).to be false
        user.follow(other_user)
        expect(user.following?(other_user)).to be true
      end
    end
  end
end