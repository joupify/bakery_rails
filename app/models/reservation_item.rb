# == Schema Information
#
# Table name: reservation_items
#
#  id               :bigint           not null, primary key
#  quantity         :integer
#  unit_price_cents :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint           not null
#  reservation_id   :bigint           not null
#
# Indexes
#
#  index_reservation_items_on_product_id      (product_id)
#  index_reservation_items_on_reservation_id  (reservation_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (reservation_id => reservations.id)
#
class ReservationItem < ApplicationRecord
  belongs_to :reservation
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
