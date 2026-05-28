require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { should belong_to(:recipient).class_name('User') }
    it { should belong_to(:actor).class_name('User').optional }
    it { should belong_to(:notifiable).optional }
  end

  describe 'enum action' do
    it 'review_posted/followed/announcement を持つこと' do
      expect(Notification.actions.keys).to contain_exactly('review_posted', 'followed', 'announcement')
    end
  end

  describe 'scopes' do
    let(:recipient) { create(:user) }
    let!(:unread_notification) { create(:notification, recipient: recipient, read_at: nil) }
    let!(:read_notification) { create(:notification, recipient: recipient, read_at: Time.current) }

    it '.unread は未読のみ返すこと' do
      expect(recipient.notifications.unread).to contain_exactly(unread_notification)
    end

    it '.recent は新着順で返すこと' do
      expect(recipient.notifications.recent.first).to eq(recipient.notifications.order(created_at: :desc).first)
    end
  end

  describe '#mark_as_read!' do
    it '未読の場合 read_at を設定すること' do
      notification = create(:notification, read_at: nil)
      expect { notification.mark_as_read! }.to change { notification.reload.read_at }.from(nil)
    end

    it '既読の場合 read_at を変更しないこと' do
      time = 1.day.ago
      notification = create(:notification, read_at: time)
      notification.mark_as_read!
      expect(notification.reload.read_at).to be_within(1.second).of(time)
    end
  end
end
