# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text
#  image       :string
#  name        :string
#  price_cents :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord
  has_many :reservation_items, dependent: :restrict_with_error
  has_many :reservations, through: :reservation_items

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }

  after_commit :may_be_create_stripe_product, on: [:create, :update]


def may_be_create_stripe_product
  return if stripe_product_id.present?

  product = Stripe::Product.create(
    name: name,
    metadata: { bakery_id: id }
  )
  update_column(:stripe_product_id, product.id)
  
  # Créer le prix
  price = Stripe::Price.create(
    product: product.id,
    unit_amount: price_cents,
    currency: "eur"
  )
  update_column(:stripe_price_id, price.id)
rescue Stripe::StripeError => e
  Rails.logger.error "Erreur Stripe: #{e.message}"
end

end