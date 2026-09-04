class WebhooksController < ApplicationController
  # skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token



  # crée un nouvel événement à chaque fois qu'un webhook est reçu
 def create
  event = Event.create(
    request_body: request.raw_post,
    source: params[:source] || 'stripe',
    event_type: 'unknown',
    status: :pending
  )

  if event.persisted?
    EventJob.perform_later(event)
    render json: { message: "success" }
  else
    Rails.logger.error("Erreur création Event: #{event.errors.full_messages.join(', ')}")
    render json: { error: event.errors.full_messages }, status: :unprocessable_entity
  end
end

end