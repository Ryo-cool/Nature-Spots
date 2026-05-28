module Notifications
  # 個人向け通知（レビュー投稿・フォロー）を1件生成するサービス。
  # フェーズ2/3で ActionCable によるブロードキャストや Web Push をこのサービスに追加する。
  class CreateNotification
    def self.call(recipient:, action:, actor: nil, notifiable: nil)
      new(recipient:, action:, actor:, notifiable:).call
    end

    def initialize(recipient:, action:, actor: nil, notifiable: nil)
      @recipient = recipient
      @action = action
      @actor = actor
      @notifiable = notifiable
    end

    def call
      # 自己通知は生成しない（自分のスポットに自分でレビュー等）
      return if actor.present? && actor == recipient

      notification = Notification.create!(
        recipient: recipient,
        actor: actor,
        action: action,
        notifiable: notifiable
      )

      # フェーズ2: NotificationBroadcaster.call(notification)
      # フェーズ3: WebPush::Deliver.call(notification)

      notification
    end

    private

    attr_reader :recipient, :action, :actor, :notifiable
  end
end
