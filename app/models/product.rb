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
class Product < ApplicationRecord
  has_many :reservation_items, dependent: :restrict_with_error
  has_many :reservations, through: :reservation_items

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  
end
