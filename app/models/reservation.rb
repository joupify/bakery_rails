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
class Reservation < ApplicationRecord
  belongs_to :user
  has_many :reservation_items, dependent: :destroy
  has_many :products, through: :reservation_items

  enum :status, {
    pending: 0,
    paid: 1,
    preparing: 2,
    ready: 3,
    collected: 4,
    cancelled: 5
  }, default: :pending

  enum :payment_method, {
    stripe: 0,
    pay_at_store: 1
  }, default: :pay_at_store

  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :pickup_time, presence: true
  validates :reservation_items, presence: true
end
