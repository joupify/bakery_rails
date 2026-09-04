require "test_helper"

# == Schema Information
#
# Table name: events
#
#  id              :bigint           not null, primary key
#  error_message   :text
#  event_type      :string
#  request_body    :text
#  source          :string
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  stripe_event_id :string
#
# Indexes
#
#  index_events_on_stripe_event_id  (stripe_event_id) UNIQUE
#
class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
