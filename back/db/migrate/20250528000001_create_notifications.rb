class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      # 通知の受信者
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      # 通知の発生源となったユーザー（運営通知の場合は nil）
      t.references :actor, foreign_key: { to_table: :users }
      # 通知種別 enum: review_posted/followed/announcement
      t.integer :action, null: false, default: 0
      # 関連オブジェクト（Review/Relationship/Announcement）
      t.references :notifiable, polymorphic: true
      # 既読日時（nil の場合は未読）
      t.datetime :read_at

      t.timestamps
    end

    # 未読カウントの主クエリ用
    add_index :notifications, [:recipient_id, :read_at]
    # 一覧の新着順ページネーション用
    add_index :notifications, [:recipient_id, :created_at]
  end
end
