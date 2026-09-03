class Product < ApplicationRecord
  has_many :reservation_items, dependent: :restrict_with_error
  has_many :reservations, through: :reservation_items

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  
end
