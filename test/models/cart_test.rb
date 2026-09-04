require "test_helper"

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
class CartTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
