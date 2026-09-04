require "test_helper"

# == Schema Information
#
# Table name: reservations
#
#  id                :bigint           not null, primary key
#  comment           :text
#  payment_method    :integer
#  pickup_time       :datetime
#  status            :integer
#  total_cents       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_session_id :string
#  user_id           :bigint           not null
#
# Indexes
#
#  index_reservations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ReservationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
