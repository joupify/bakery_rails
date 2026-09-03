class Event < ApplicationRecord
	enum :status, {
		pending: 0,
		processing: 1,
		processed: 2,
		failed: 3
	}, default: :pending

	validates :source, :request_body, :stripe_event_id, presence: true
end
