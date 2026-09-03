class CartsController < ApplicationController
  include CurrentCart

  before_action :ensure_session_id
  before_action :set_cart

  def show
    @items = @cart.items.includes(:product)
    @total_cents = @items.sum { |item| item.product.price_cents * item.quantity }
  end

  def add_product
    product = Product.find(params[:product_id])
    @cart.add_product(product.id)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Produit ajouté au panier." }
    end
  end

  def remove_item
    if @cart.remove_item(params[:product_id])
      redirect_to cart_path, notice: "Produit retiré du panier."
    else
      redirect_to cart_path, alert: "Produit absent du panier."
    end
  end

  def update_quantity
    item = @cart.items.find_by!(product_id: params[:product_id])
    item.update!(quantity: params[:quantity].to_i)
    redirect_to cart_path, notice: "Quantité mise à jour."
  end

  private
end
