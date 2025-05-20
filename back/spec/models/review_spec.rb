require 'rails_helper'

RSpec.describe Review, type: :model do
  subject do
    described_class.new(
      title: 'タイトル',
      text: 'レビュー本文です' * 2,
      rating: 3,
      user_id: 1,
      spot_id: 1
    )
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without a title' do
      subject.title = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without text' do
      subject.text = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:text]).to include("can't be blank")
    end

    it 'is invalid without a rating' do
      subject.rating = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:rating]).to include("can't be blank")
    end

    it 'is invalid with rating less than 1' do
      subject.rating = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:rating]).to include('must be greater than or equal to 1')
    end

    it 'is invalid with rating greater than 5' do
      subject.rating = 6
      expect(subject).not_to be_valid
      expect(subject.errors[:rating]).to include('must be less than or equal to 5')
    end
  end
end
