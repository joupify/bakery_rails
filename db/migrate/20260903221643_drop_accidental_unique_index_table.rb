class DropAccidentalUniqueIndexTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :unique_index_on_events_stripe_event_ids, if_exists: true
  end
end
