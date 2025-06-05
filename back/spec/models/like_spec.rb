require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    let(:valid_like) { build(:like) }

    it '有効ないいねが作成できること' do
      expect(valid_like).to be_valid
    end

    it 'ユーザーとレビューの組み合わせが一意であること' do
      user = create(:user)
      review = create(:review)
      create(:like, user: user, review: review)
      duplicate_like = build(:like, user: user, review: review)
      expect(duplicate_like).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:review) }
  end
end
