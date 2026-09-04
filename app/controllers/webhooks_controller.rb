# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  # skip_before_action :authenticate_user!
  # skip_before_action :verify_authenticity_token
  skip_before_action :verify_authenticity_token, raise: false


  def create
    # Extraire les données du payload
    data = JSON.parse(request.raw_post) rescue {}
    stripe_event_id = data['id']  # L'ID de l'événement Stripe (ex: evt_xxx)
    event_type = data['type'] || 'unknown'

    event = Event.new(
      request_body: request.raw_post,
      source: params[:source] || 'stripe',
      event_type: event_type,
      stripe_event_id: stripe_event_id,  # ✅ AJOUTER CECI
      status: :pending
    )

    if event.save
      EventJob.perform_later(event)
      render json: { message: "success" }, status: :ok
    else
      Rails.logger.error("❌ Erreur création Event: #{event.errors.full_messages.join(', ')}")
      render json: { error: event.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("❌ Webhook error: #{e.message}")
    render json: { error: e.message }, status: :internal_server_error
  end
end