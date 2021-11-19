# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  role                   :integer          default("client"), not null
#  first_name             :string
#  last_name              :string
#  notifications          :integer          default("do not notify")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  locked_at              :datetime
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  has_many :organizations
  has_many :reservations,  dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :comments,      dependent: :destroy

  enum role: {
    client: 0,
    owner: 1,
    admin: 2
  }

  enum notifications: {
    'do not notify': 0,
    '15 minutes': 1,
    '3 hours': 2,
    '1 day': 3
  }
end
