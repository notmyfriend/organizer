# == Schema Information
#
# Table name: time_slots
#
#  id                      :bigint           not null, primary key
#  organization_service_id :bigint           not null
#  status                  :integer          default("vacant"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  start_time              :datetime         not null
#  end_time                :datetime         not null
#
class TimeSlot < ApplicationRecord
  belongs_to :organization_service
  has_one :reservation,    dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  enum status: {
    vacant: 0,
    booked: 1
  }
end
