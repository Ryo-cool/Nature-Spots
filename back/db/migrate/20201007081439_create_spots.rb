class CreateSpots < ActiveRecord::Migration[6.0]
  def change
    create_table :spots do |t|
      t.string :name
      t.text :introduction
      t.string :location
      t.string :photo
      t.string :addess
      t.integer :prefecture_id
      t.timestamps
    end
  end
end
