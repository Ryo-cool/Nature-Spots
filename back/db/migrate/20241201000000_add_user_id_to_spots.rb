class AddUserIdToSpots < ActiveRecord::Migration[7.1]
  def change
    add_reference :spots, :user, null: false, foreign_key: true
  end
end 