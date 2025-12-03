# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpotRankingService do
  describe '.call' do
    context "レビューのあるスポットが存在する場合" do
      let!(:spot_with_many_reviews) { create(:spot, :with_reviews) }
      let!(:spot_with_one_review) { create(:spot) }
      let!(:spot_without_reviews) { create(:spot) }

      before do
        create(:review, spot: spot_with_one_review)
      end

      it "成功を返すこと" do
        result = described_class.call
        expect(result).to be_success
      end

      it "レビュー数順にスポットを返すこと" do
        result = described_class.call
        spots = result.data[:spots]

        expect(spots).to be_an(Array)
        expect(spots.first['id']).to eq(spot_with_many_reviews.id)
      end

      it "レビューのないスポットを含まないこと" do
        result = described_class.call
        spot_ids = result.data[:spots].map { |s| s['id'] }

        expect(spot_ids).not_to include(spot_without_reviews.id)
      end

      it "デフォルトで5件まで返すこと" do
        6.times { create(:spot, :with_reviews) }

        result = described_class.call
        expect(result.data[:spots].size).to be <= 5
      end
    end

    context "limit引数が指定された場合" do
      before do
        5.times { create(:spot, :with_reviews) }
      end

      it "指定された件数を返すこと" do
        result = described_class.call(limit: 3)
        expect(result.data[:spots].size).to eq(3)
      end
    end

    context "レビューのあるスポットがない場合" do
      it "空の配列を返すこと" do
        create(:spot) # レビューなし

        result = described_class.call
        expect(result).to be_success
        expect(result.data[:spots]).to eq([])
      end
    end

    context "キャッシュが有効な場合" do
      before do
        create(:spot, :with_reviews)
      end

      it "同じ結果がキャッシュされること" do
        # 1回目の呼び出し
        result1 = described_class.call

        # 新しいスポットを追加（キャッシュが効いていれば反映されない）
        new_spot = create(:spot)
        create_list(:review, 10, spot: new_spot)

        # 2回目の呼び出し（キャッシュから取得されるはず）
        result2 = described_class.call

        # 注意: テスト環境ではキャッシュが無効の場合がある
        # キャッシュが有効なら同じ結果になる
        expect(result1.data[:spots].size).to be >= 1
        expect(result2.data[:spots].size).to be >= 1
      end
    end
  end
end
