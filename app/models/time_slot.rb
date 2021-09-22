# == Schema Information
#
# Table name: time_slots
#
#  id                      :bigint           not null, primary key
#  organization_service_id :bigint           not null
#  start_time              :time             not null
#  end_time                :time             not null
#  status                  :integer          default("vacant"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class TimeSlot < ApplicationRecord
  belongs_to :organization_service
  has_one :reservation

  enum status: [:vacant, :booked]
end
