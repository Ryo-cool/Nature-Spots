require 'rails_helper'

RSpec.describe Notifications::Announce, type: :service do
  let(:admin) { create(:user) }
  let(:announcement) { create(:announcement, author: admin) }

  it '全アクティブユーザーへ通知を生成すること' do
    active_users = create_list(:user, 3)
    create(:user, :inactive)
    announcement # author(admin) を先に生成しておく
    active_count = User.where(activated: true).count

    expect {
      described_class.call(announcement)
    }.to change(Notification, :count).by(active_count)

    active_users.each do |user|
      expect(user.notifications.where(notifiable: announcement, action: :announcement)).to exist
    end
  end

  it '非アクティブユーザーには生成しないこと' do
    inactive = create(:user, :inactive)
    described_class.call(announcement)
    expect(inactive.notifications.count).to eq(0)
  end
end
