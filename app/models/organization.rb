class Organization < ApplicationRecord
  belongs_to :user, -> { where role: :owner }
  has_many :organization_services
  has_many :services, through: :organization_services
end
