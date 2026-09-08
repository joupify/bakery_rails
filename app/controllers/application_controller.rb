class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :cart_item_count

  private

  def cart_item_count
    return 0 unless session[:session_id]

    cart = Cart.find_by(session_id: session[:session_id])
    cart ? cart.items.sum(:quantity) : 0
  end
end
