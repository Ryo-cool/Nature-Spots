require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    let(:valid_review) { build(:review) }

    it '有効なレビューが作成できること' do
      expect(valid_review).to be_valid
    end

    describe 'rating' do
      it '評価が必須であること' do
        valid_review.rating = nil
        expect(valid_review).not_to be_valid
      end

      it '評価が1以上であること' do
        valid_review.rating = 0
        expect(valid_review).not_to be_valid
      end

      it '評価が5以下であること' do
        valid_review.rating = 6
        expect(valid_review).not_to be_valid
      end
    end

    describe 'title' do
      it 'タイトルが必須であること' do
        valid_review.title = nil
        expect(valid_review).not_to be_valid
      end

      it 'タイトルが2文字以上であること' do
        valid_review.title = 'あ'
        expect(valid_review).not_to be_valid
      end

      it 'タイトルが100文字以下であること' do
        valid_review.title = 'あ' * 101
        expect(valid_review).not_to be_valid
      end
    end

    describe 'content' do
      it 'コンテンツが必須であること' do
        valid_review.content = nil
        expect(valid_review).not_to be_valid
      end

      it 'コンテンツが10文字以上であること' do
        valid_review.content = 'あ' * 9
        expect(valid_review).not_to be_valid
      end

      it 'コンテンツが1000文字以下であること' do
        valid_review.content = 'あ' * 1001
        expect(valid_review).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:spot) }
    it { should have_many(:likes) }
  end
end
