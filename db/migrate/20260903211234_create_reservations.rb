class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.integer :payment_method
      t.integer :total_cents
      t.datetime :pickup_time
      t.text :comment
      t.string :stripe_session_id

      t.timestamps
    end
  end
end
