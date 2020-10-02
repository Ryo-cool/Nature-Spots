class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :image
      t.text   :introduction
      t.boolean :activated, default: false
      t.boolean :admin, default: false
      t.timestamps
    end
  end
end
