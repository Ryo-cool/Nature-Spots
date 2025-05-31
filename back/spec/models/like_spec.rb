require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    let(:valid_like) { build(:like) }

    it '有効ないいねが作成できること' do
      expect(valid_like).to be_valid
    end

    it 'ユーザーとレビューの組み合わせが一意であること' do
      create(:like, user: valid_like.user, review: valid_like.review)
      expect(valid_like).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:review) }
  end
end
