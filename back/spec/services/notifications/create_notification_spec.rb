require 'rails_helper'

RSpec.describe Notifications::CreateNotification, type: :service do
  let(:recipient) { create(:user) }
  let(:actor) { create(:user) }

  it '通知を1件生成すること' do
    expect {
      described_class.call(recipient: recipient, actor: actor, action: :followed)
    }.to change(Notification, :count).by(1)
  end

  it '生成された通知の属性が正しいこと' do
    notification = described_class.call(recipient: recipient, actor: actor, action: :followed)
    expect(notification.recipient).to eq(recipient)
    expect(notification.actor).to eq(actor)
    expect(notification.action).to eq('followed')
  end

  it 'actor と recipient が同一の場合は生成しないこと（自己通知の除外）' do
    expect {
      described_class.call(recipient: recipient, actor: recipient, action: :followed)
    }.not_to change(Notification, :count)
  end

  it 'actor が nil の場合は生成すること（運営通知など）' do
    expect {
      described_class.call(recipient: recipient, action: :announcement)
    }.to change(Notification, :count).by(1)
  end
end
