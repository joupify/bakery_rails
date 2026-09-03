class ReservationsController < ApplicationController
  include CurrentCart

  before_action :authenticate_user!
  before_action :ensure_session_id
  before_action :set_cart

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

    @cart.items.each do |cart_item|
      @reservation.reservation_items.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        unit_price_cents: cart_item.product.price_cents
      )
    end

    if @reservation.save
      @cart.items.destroy_all
      if @reservation.stripe?
        redirect_to checkout_reservation_path(@reservation)
      else
        redirect_to reservation_path(@reservation), notice: "Réservation créée avec succès."
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
      success_url: reservation_url(reservation),
      cancel_url: reservation_url(reservation)
    )

    reservation.update!(stripe_session_id: checkout_session.id)
    redirect_to checkout_session.url, allow_other_host: true
  end

  private

  def reservation_params
    params.require(:reservation).permit(:pickup_time, :payment_method, :comment)
  end
end