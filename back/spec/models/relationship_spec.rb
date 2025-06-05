require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'validations' do
    let(:valid_relationship) { build(:relationship) }

    it '有効なフォロー関係が作成できること' do
      user = create(:user)
      follow_user = create(:user)
      relationship = build(:relationship, user: user, follow: follow_user)
      expect(relationship).to be_valid
    end

    it 'ユーザーとフォロー対象の組み合わせが一意であること' do
      user = create(:user)
      follow_user = create(:user)
      create(:relationship, user: user, follow: follow_user)
      duplicate_relationship = build(:relationship, user: user, follow: follow_user)
      expect(duplicate_relationship).not_to be_valid
    end

    it '自分自身をフォローできないこと' do
      user = create(:user)
      relationship = build(:relationship, user: user, follow: user)
      expect(relationship).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:follow).class_name('User') }
  end
end
