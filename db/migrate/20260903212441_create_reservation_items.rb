class CreateReservationItems < ActiveRecord::Migration[8.1]
  def change
    create_table :reservation_items do |t|
      t.references :reservation, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.integer :unit_price_cents

      t.timestamps
    end
  end
end
