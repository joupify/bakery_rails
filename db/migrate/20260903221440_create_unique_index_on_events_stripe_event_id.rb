class CreateUniqueIndexOnEventsStripeEventId < ActiveRecord::Migration[8.1]
  def up
    add_index :events, :stripe_event_id, unique: true
  end

  def down
    remove_index :events, :stripe_event_id if index_exists?(:events, :stripe_event_id)
  end
end
