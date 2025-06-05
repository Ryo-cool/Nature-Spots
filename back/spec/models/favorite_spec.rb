require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'validations' do
    let(:valid_favorite) { build(:favorite) }

    it '有効なお気に入りが作成できること' do
      expect(valid_favorite).to be_valid
    end

    it 'ユーザーとスポットの組み合わせが一意であること' do
      user = create(:user)
      spot = create(:spot)
      create(:favorite, user: user, spot: spot)
      duplicate_favorite = build(:favorite, user: user, spot: spot)
      expect(duplicate_favorite).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:spot) }
  end
end
