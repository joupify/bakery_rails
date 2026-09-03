class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :source
      t.text :request_body
      t.string :event_type
      t.integer :status
      t.text :error_message

      t.timestamps
    end
  end
end
