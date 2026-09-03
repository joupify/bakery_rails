class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, class_name: "CartItem", dependent: :destroy
  has_many :products, through: :items

  validates :session_id, presence: true

  def add_product(product_id)
    item = items.find_or_initialize_by(product_id: product_id)
    item.quantity = item.quantity.to_i + 1
    item.save!
  end

  def remove_item(product_id)
    items.find_by(product_id: product_id)&.destroy
  end
end
