class CreateAnnouncements < ActiveRecord::Migration[7.2]
  def change
    create_table :announcements do |t|
      # お知らせを作成した管理者
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :body, null: false
      # 公開日時（nil の場合は下書き扱い）
      t.datetime :published_at

      t.timestamps
    end

    add_index :announcements, :published_at
  end
end
