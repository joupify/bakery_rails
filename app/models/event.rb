# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  error_message   :text
#  event_type      :string
#  request_body    :text
#  source          :string
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  stripe_event_id :string
#
# Indexes
#
#  index_events_on_stripe_event_id  (stripe_event_id) UNIQUE
#
class Event < ApplicationRecord
	enum :status, {
		pending: 0,
		processing: 1,
		processed: 2,
		failed: 3
	}, default: :pending

	validates :source, :request_body, :stripe_event_id, presence: true
end
