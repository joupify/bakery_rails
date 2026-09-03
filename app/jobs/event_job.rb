class EventJob < ApplicationJob
  queue_as :default

  retry_on ActiveRecord::RecordNotFound, wait: :exponentially_longer, attempts: 3

  def perform(event)
    event.update!(status: :processing)
    stripe_event = Stripe::Event.construct_from(
      JSON.parse(event.request_body, symbolize_names: true)
    )

    handle_stripe(stripe_event)
    event.update!(event_type: stripe_event.type, error_message: nil, status: :processed)
  rescue StandardError => error
    Rails.logger.error("Error processing Event #{event.id}: #{error.message}")
    event.update(status: :failed, error_message: error.message) if event.persisted?
    raise
  end

  private

  def handle_stripe(stripe_event)
    case stripe_event.type
    when "checkout.session.completed"
      checkout_session = stripe_event.data.object
      reservation = Reservation.find_by!(stripe_session_id: checkout_session.id)
      reservation.update!(status: :paid)
    end
  end
end
