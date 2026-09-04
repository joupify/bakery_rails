require "test_helper"

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
class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
