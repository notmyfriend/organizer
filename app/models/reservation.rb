# == Schema Information
#
# Table name: reservations
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  time_slot_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot
end
