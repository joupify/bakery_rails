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
  validate :pickup_time_during_business_hours
  validate :pickup_time_within_delay


  private

  def pickup_time_during_business_hours
    return if pickup_time.blank?

    pickup_time_of_day = pickup_time.seconds_since_midnight
    opening_time = 7.hours
    # Dernier créneau : 17h00 (2h avant la fermeture à 19h)
    last_slot = 17.hours

    unless pickup_time_of_day.between?(opening_time, last_slot)
      errors.add(:pickup_time, "doit être compris entre 07h00 et 17h00")
    end
  end

  def pickup_time_within_delay
    return if pickup_time.blank?

    # Le retrait doit être au moins 2h après la commande
    if pickup_time < 2.hours.from_now
      errors.add(:pickup_time, "doit être au moins 2h après la commande")
    end
  end

  # Génération des créneaux
  def self.available_pickup_hours(date = Date.current)
    date = Date.parse(date.to_s) unless date.is_a?(Date)
    base_date = date.in_time_zone.beginning_of_day
    
    # Si la date est dans le futur, tous les créneaux sont disponibles
    if base_date.to_date > Date.current
      return (7...17).flat_map { |hour| ["%02d:00" % hour, "%02d:30" % hour] } + ["17:00"]
    end
    
    # Si c'est aujourd'hui, filtrer selon l'heure actuelle + 2h
    min_time = 2.hours.from_now.in_time_zone
    available_hours = []
    
    (7...17).each do |hour|
      [0, 30].each do |minute|
        slot_time = base_date.change(hour: hour, min: minute)
        if slot_time >= min_time
          available_hours << slot_time.strftime("%H:%M")
        end
      end
    end
    
    # Ajouter 17:00 si disponible
    last_slot = base_date.change(hour: 17, min: 0)
    available_hours << "17:00" if last_slot >= min_time
    
    available_hours
  end

end


