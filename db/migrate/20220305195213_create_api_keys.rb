class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :api_keys, :token, unique: true
  end
end
