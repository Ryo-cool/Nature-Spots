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

    describe 'text' do
      it 'コンテンツが必須であること' do
        valid_review.text = nil
        expect(valid_review).not_to be_valid
      end

      it 'コンテンツが10文字以上であること' do
        valid_review.text = 'あ' * 9
        expect(valid_review).not_to be_valid
      end

      it 'コンテンツが2000文字以下であること' do
        valid_review.text = 'あ' * 2001
        expect(valid_review).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:spot) }
    it { should have_many(:likes) }
  end

  describe '通知の生成' do
    it 'レビュー投稿時にスポット投稿者へ通知が生成されること' do
      spot_owner = create(:user)
      reviewer = create(:user)
      spot = create(:spot, user: spot_owner)
      expect {
        create(:review, spot: spot, user: reviewer)
      }.to change { spot_owner.notifications.where(action: :review_posted).count }.by(1)
    end

    it '自分のスポットに自分でレビューした場合は通知が生成されないこと（自己通知の除外）' do
      owner = create(:user)
      spot = create(:spot, user: owner)
      expect {
        create(:review, spot: spot, user: owner)
      }.not_to change(Notification, :count)
    end
  end
end
