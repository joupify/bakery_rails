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
  test "available pickup hours exclude past slots and the two hour delay today" do
    travel_to Time.zone.local(2026, 9, 10, 10, 15)

    assert_equal ["12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00"],
                 Reservation.available_pickup_hours(Date.current)
  ensure
    travel_back
  end

  test "available pickup hours include every slot for a future date" do
    hours = Reservation.available_pickup_hours(Date.current + 1.day)

    assert_equal "07:00", hours.first
    assert_equal "17:00", hours.last
    assert_equal 21, hours.length
  end
end
