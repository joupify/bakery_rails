module CurrentCart
  extend ActiveSupport::Concern

  private

  def ensure_session_id
    session[:session_id] ||= SecureRandom.hex(10)
  end

  def current_cart
    Cart.find_or_create_by!(session_id: session[:session_id])
  end

  def set_cart
    @cart = current_cart

    if user_signed_in? && @cart.user_id.nil?
      @cart.update!(user: current_user)
    end
  end
end
