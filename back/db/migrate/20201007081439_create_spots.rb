class CreateSpots < ActiveRecord::Migration[6.0]
  def change
    create_table :spots do |t|
      t.string :name
      t.text :introduction
      t.string :photo
      t.string :address
      t.integer :prefecture_id
      t.integer :location_id
      t.timestamps
    end
  end
end
