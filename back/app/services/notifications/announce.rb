module Notifications
  # 運営からのお知らせを全アクティブユーザーへ fan-out するサービス。
  # メモリ効率のため find_in_batches + insert_all で一括挿入する。
  # 注: insert_all はモデルコールバックを発火しないため、リアルタイム配信や
  #     Web Push はフェーズ2/3で別途扱う（件数が膨大になるため）。
  class Announce
    BATCH_SIZE = 1000

    def self.call(announcement)
      new(announcement).call
    end

    def initialize(announcement)
      @announcement = announcement
    end

    def call
      now = Time.current
      action_value = Notification.actions[:announcement]

      User.where(activated: true).select(:id).find_in_batches(batch_size: BATCH_SIZE) do |batch|
        rows = batch.map do |user|
          {
            recipient_id: user.id,
            action: action_value,
            notifiable_type: "Announcement",
            notifiable_id: announcement.id,
            created_at: now,
            updated_at: now
          }
        end
        Notification.insert_all(rows) if rows.any?
      end
    end

    private

    attr_reader :announcement
  end
end
