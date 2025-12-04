# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDataService do
  describe '.call' do
    let(:user) { create(:user) }

    context "ユーザーデータが正常に取得できる場合" do
      let!(:spot) { create(:spot, user: user) }
      let!(:review) { create(:review, user: user, spot: spot) }
      let!(:other_review) { create(:review) }
      let!(:like) { create(:like, user: user, review: other_review) }
      let!(:favorite) { create(:favorite, user: user, spot: spot) }
      let(:other_user) { create(:user) }

      before do
        user.follow(other_user)
        other_user.follow(user)
      end

      it "成功を返すこと" do
        result = described_class.call(user)
        expect(result).to be_success
      end

      it "ユーザー情報を含むこと" do
        result = described_class.call(user)
        expect(result.data[:user][:id]).to eq(user.id)
      end

      it "ユーザーのレビュー一覧を含むこと" do
        result = described_class.call(user)
        expect(result.data[:reviews]).to be_an(Array)
        expect(result.data[:reviews].size).to eq(1)
      end

      it "いいねしたレビュー一覧を含むこと" do
        result = described_class.call(user)
        expect(result.data[:liked_reviews]).to be_an(Array)
        expect(result.data[:liked_reviews].size).to eq(1)
      end

      it "お気に入りスポット一覧を含むこと" do
        result = described_class.call(user)
        expect(result.data[:favorites]).to be_an(Array)
        expect(result.data[:favorites].size).to eq(1)
      end

      it "フォロー一覧を含むこと" do
        result = described_class.call(user)
        expect(result.data[:followings]).to be_an(Array)
        expect(result.data[:followings].size).to eq(1)
      end

      it "フォロワー一覧を含むこと" do
        result = described_class.call(user)
        expect(result.data[:followers]).to be_an(Array)
        expect(result.data[:followers].size).to eq(1)
      end
    end

    context "関連データがない場合" do
      it "空の配列を返すこと" do
        result = described_class.call(user)

        expect(result).to be_success
        expect(result.data[:reviews]).to eq([])
        expect(result.data[:liked_reviews]).to eq([])
        expect(result.data[:favorites]).to eq([])
        expect(result.data[:followings]).to eq([])
        expect(result.data[:followers]).to eq([])
      end
    end
  end
end
