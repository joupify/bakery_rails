# app/jobs/event_job.rb
class EventJob < ApplicationJob
  queue_as :default

  retry_on ActiveRecord::RecordNotFound, wait: :exponentially_longer, attempts: 3

  def perform(event)
    Rails.logger.info "Processing Event: #{event.id} with source: #{event.source}"

    case event.source
    when "stripe"
      begin
        stripe_event = Stripe::Event.construct_from(JSON.parse(event.request_body, symbolize_names: true))
        handle_stripe(stripe_event)

        event.update(
          event_type: stripe_event.type,
          error_message: "",
          status: :processed
        )

      rescue => e
        Rails.logger.error "Error processing event: #{e.message}"
        event.update(
          error_message: e.message,
          status: :failed
        )
      end
    else
      event.update(
        error_message: "unknown source #{event.source}",
        status: :failed
      )
    end
  end

  def handle_stripe(event)
    puts "Handling stripe event: #{event.type}"

    case event.type

    when "account.updated"
      puts "Handling account.updated event"
      account = event.data.object
      puts "Event data: #{event.inspect}"

      user = User.find_by(stripe_account_id: account.id)
      if user.nil?
        puts "User not found for stripe_account_id: #{account.id}"
      else
        puts "Updating charges_enabled for user: #{user.id}"
        user.update(charges_enabled: account.charges_enabled)
        puts "charges_enabled updated: #{user.charges_enabled}"
      end

    when "checkout.session.completed"
      checkout_session = event.data.object
      
      Rails.logger.info "=== WEBHOOK REÇU ==="
      Rails.logger.info "Session ID from Stripe: #{checkout_session.id}"
      Rails.logger.info "Payment Intent from Stripe: #{checkout_session.payment_intent}"
      Rails.logger.info "Metadata: #{checkout_session.metadata}"
      
      # 🔥 CHANGEMENT 1: Utiliser Reservation au lieu de Order
      reservation = Reservation.find_by(stripe_session_id: checkout_session.id)
      
      # 🔥 CHANGEMENT 2: Fallback via metadata
      if reservation.nil? && checkout_session.metadata && checkout_session.metadata.reservation_id
        reservation = Reservation.find_by(id: checkout_session.metadata.reservation_id)
        if reservation
          reservation.update(stripe_session_id: checkout_session.id)
        end
      end

      if reservation.nil?
        Rails.logger.error "Reservation introuvable. SessionID: #{checkout_session.id}, Metadata: #{checkout_session.metadata}"
        raise "Réservation non trouvée"
      end

      # 🔥 CHANGEMENT 3: Vider le panier
      if reservation.user&.cart
        items_count = reservation.user.cart.items.count
        reservation.user.cart.items.destroy_all
        Rails.logger.info "Panier vidé pour la réservation #{reservation.id} (#{items_count} items supprimés)"
      end

      # 🔥 CHANGEMENT 4: Mettre à jour le statut (paid au lieu de :paid)
      reservation.update!(status: :paid)
      Rails.logger.info "Réservation #{reservation.id} marquée comme payée"
      
      Rails.logger.info "Reservations in DB: #{Reservation.pluck(:stripe_session_id)}"

    when "checkout.session.expired"
      checkout_session = event.data.object
      # 🔥 CHANGEMENT: Reservation au lieu de Order
      reservation = Reservation.find_by(stripe_session_id: checkout_session.id)
      if reservation.nil?
        raise "No Reservation Found with Checkout Session ID: #{checkout_session.id}"
      end
      reservation.update(status: :cancelled)

    when "identity_verification_session_verified"
      session = event.data.object
      user = User.find_by(id: session.metadata.user_id)
      if user.nil?
        raise "No User found with this ID: #{session.metadata.user_id}"
      end
      if session.status == "verified"
        user.update(identity_verified: true)
      else
        user.update(identity_verified: false)
      end

    when "charge.refunded"
      charge = event.data.object
      # 🔥 CHANGEMENT: Reservation au lieu de Order
      reservation = Reservation.find_by(stripe_session_id: charge.payment_intent)
      if reservation.nil?
        raise "No Reservation Found with Payment Intent ID: #{charge.payment_intent}"
      end
      reservation.update(status: :cancelled)
      
      puts "Payment Intent ID: #{charge.payment_intent}"
      puts "Reservation Metadata: #{reservation.metadata}" if reservation.respond_to?(:metadata)

    end
  end
end