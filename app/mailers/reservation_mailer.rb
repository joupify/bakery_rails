class ReservationMailer < ApplicationMailer
  def confirmation(reservation)
    @reservation = reservation
    @user = reservation.user
    @items = reservation.reservation_items.includes(:product)
    
    mail(
      to: @user.email,
      subject: "Confirmation de votre réservation ##{reservation.id}"
    )
  end
end