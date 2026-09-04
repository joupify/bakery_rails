# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :string
#  user_id    :bigint
#
# Indexes
#
#  index_carts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
