class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.string :restaurant_name

      t.timestamps
    end

    add_index :favorites, [:user_id, :restaurant_name], unique: true
  end
end
