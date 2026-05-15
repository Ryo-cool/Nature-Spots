class CreateSpotSeasons < ActiveRecord::Migration[7.1]
  def change
    create_table :spot_seasons do |t|
      t.references :spot, null: false, foreign_key: true, index: false
      t.integer :season_id, null: false

      t.timestamps
    end

    add_index :spot_seasons, [:spot_id, :season_id], unique: true
    add_index :spot_seasons, :season_id
  end
end
