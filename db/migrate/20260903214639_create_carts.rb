class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true
      t.string :session_id, null: false

      t.timestamps
    end
  end
end
