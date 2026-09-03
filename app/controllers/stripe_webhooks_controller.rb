class StripeWebhooksController < ApplicationController
  skip_forgery_protection

  def create
    payload = request.raw_post
    signature = request.headers["Stripe-Signature"]

    stripe_event = Stripe::Webhook.construct_event(
      payload,
      signature,
      ENV.fetch("STRIPE_WEBHOOK_SECRET")
    )

    event = Event.find_or_create_by!(stripe_event_id: stripe_event.id) do |record|
      record.source = "stripe"
      record.request_body = payload
      record.event_type = stripe_event.type
      record.status = :pending
    end

    EventJob.perform_later(event) if event.pending? || event.failed?
    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError => error
    Rails.logger.warn("Invalid Stripe webhook: #{error.message}")
    head :bad_request
  rescue ActiveRecord::RecordNotUnique
    head :ok
  end
end
