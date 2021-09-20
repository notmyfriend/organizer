class Service < ApplicationRecord
  has_many :organization_services
  has_many :organizations, through: :organization_services
end
