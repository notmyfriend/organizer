class TimeSlot < ApplicationRecord
  belongs_to :organization_service
  has_one :reservation

  enum status: [:vacant, :booked]
end
