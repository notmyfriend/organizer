# == Schema Information
#
# Table name: subscriptions
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  time_slot_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot
end
