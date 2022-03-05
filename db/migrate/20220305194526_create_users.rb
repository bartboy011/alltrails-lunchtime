class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end