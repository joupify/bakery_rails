class AddStripeEventIdToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :stripe_event_id, :string
  end
end
