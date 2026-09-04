require "test_helper"

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
class ReservationItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
