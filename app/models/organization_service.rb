class OrganizationService < ApplicationRecord
  belongs_to :organization
  belongs_to :service
  has_many :workers
  has_many :time_slots
end
