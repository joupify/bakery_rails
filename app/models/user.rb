# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_one :cart, dependent: :destroy  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         after_commit :may_be_create_stripe_customer, on: [:create, :update]

  def may_be_create_stripe_customer
    return if !stripe_customer_id.blank?

    customer = Stripe::Customer.create(
      email: email,
      name: name,
      metadata: {
      bakery_id: id
      },

      
    )
    update(stripe_customer_id: customer.id)  #update locally when come back from stripe
  end


end
