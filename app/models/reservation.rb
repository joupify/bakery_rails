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
