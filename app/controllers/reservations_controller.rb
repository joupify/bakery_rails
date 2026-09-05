# app/controllers/reservations_controller.rb
class ReservationsController < ApplicationController
  include CurrentCart

  before_action :authenticate_user!
  before_action :ensure_session_id
  before_action :set_cart
  rescue_from ActiveRecord::RecordNotFound, with: :cart_not_found

  def index
    @reservations = current_user.reservations.includes(reservation_items: :product).order(created_at: :desc)
  end

  def new
    @reservation = current_user.reservations.new(
      total_cents: @cart.items.sum { |item| item.product.price_cents * item.quantity },
      payment_method: :pay_at_store
    )
  end

  def create
    if @cart.items.empty?
      redirect_to cart_path, alert: "Votre panier est vide."
      return
    end

    @reservation = current_user.reservations.build(reservation_params)
    @reservation.total_cents = @cart.items.sum { |item| item.product.price_cents * item.quantity }
    @reservation.status = :pending

    @cart.items.each do |cart_item|
      @reservation.reservation_items.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        unit_price_cents: cart_item.product.price_cents
      )
    end

    if @reservation.save
      if params[:payment_action] == "pay_at_store"
        @cart.items.destroy_all
        redirect_to reservation_path(@reservation), notice: "Réservation créée avec succès."
      else
        # Stripe - NE PAS VIDER LE PANIER
        redirect_to checkout_reservation_path(@reservation)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @reservation = current_user.reservations.includes(reservation_items: :product).find(params[:id])
  end

  def checkout
    reservation = current_user.reservations.find(params[:id])
    checkout_session = Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: reservation.reservation_items.includes(:product).map do |item|
        {
          price_data: {
            currency: "eur",
            product_data: { name: item.product.name },
            unit_amount: item.unit_price_cents
          },
          quantity: item.quantity
        }
      end,
      metadata: { reservation_id: reservation.id },
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: reservation_url(reservation)
    )

    reservation.update!(stripe_session_id: checkout_session.id)
    redirect_to checkout_session.url, allow_other_host: true
  end

  def checkout_success
    session_id = params[:session_id]
    reservation = Reservation.find_by(stripe_session_id: session_id)

    if reservation.nil?
      redirect_to root_path, alert: 'Réservation introuvable. Veuillez contacter le support.'
      return
    end

    # ✅ VIDER LE PANIER ICI
    if @cart.present?
      items_count = @cart.items.count
      @cart.items.destroy_all
      Rails.logger.info "✅ Panier vidé pour la réservation #{reservation.id} (#{items_count} items)"
    end

    # Mettre à jour le statut
    reservation.update!(status: :paid)

    redirect_to reservation_path(reservation), notice: 'Paiement confirmé. Merci pour votre commande !'
  end

  # app/controllers/reservations_controller.rb
# app/controllers/reservations_controller.rb
def expire
  reservation = current_user.reservations.find(params[:id])
  
  # Expirer la session Stripe
  if reservation.stripe_session_id.present?
    begin
      Stripe::Checkout::Session.expire(reservation.stripe_session_id)
    rescue => e
      Rails.logger.error "Erreur expiration Stripe: #{e.message}"
    end
  end
  
  # Marquer la réservation comme annulée
  reservation.update!(status: :cancelled)
  
  redirect_to cart_path, notice: "Session expirée. Votre panier a été conservé."
end

  private

  def reservation_params
    params.require(:reservation).permit(:pickup_time, :payment_method, :comment)
  end

  def ensure_session_id
    session[:session_id] ||= SecureRandom.hex(10)
  end

  def cart_not_found
    redirect_to root_path, alert: 'Cart not found.'
  end
end