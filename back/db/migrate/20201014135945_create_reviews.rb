class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :text
      t.string :wentday
      t.integer :rating
      t.string :image
      t.references :spot, foreign_key: true
      t.timestamps
    end
  end
end
