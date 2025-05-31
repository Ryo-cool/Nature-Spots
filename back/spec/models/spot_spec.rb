require 'rails_helper'

RSpec.describe Spot, type: :model do
  describe 'validations' do
    let(:valid_spot) { build(:spot) }

    it '有効なスポットが作成できること' do
      expect(valid_spot).to be_valid
    end

    describe 'name' do
      it '名前が必須であること' do
        valid_spot.name = nil
        expect(valid_spot).not_to be_valid
        expect(valid_spot.errors[:name]).to include("を入力してください")
      end

      it '名前が2文字以上であること' do
        valid_spot.name = 'あ'
        expect(valid_spot).not_to be_valid
      end

      it '名前が100文字以下であること' do
        valid_spot.name = 'あ' * 101
        expect(valid_spot).not_to be_valid
      end
    end

    describe 'address' do
      it '住所が必須であること' do
        valid_spot.address = nil
        expect(valid_spot).not_to be_valid
      end
    end

    describe 'prefecture_id' do
      it '都道府県が必須であること' do
        valid_spot.prefecture_id = nil
        expect(valid_spot).not_to be_valid
      end
    end

    describe 'location_id' do
      it '地域が必須であること' do
        valid_spot.location_id = nil
        expect(valid_spot).not_to be_valid
      end
    end

    describe 'photo' do
      it '写真が必須であること' do
        valid_spot.photo = nil
        expect(valid_spot).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:prefecture) }
    it { should have_many(:reviews) }
    it { should have_many(:favorites) }
  end
end
