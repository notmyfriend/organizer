# == Schema Information
#
# Table name: services
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Service < ApplicationRecord
  has_many :organization_services
  has_many :organizations, through: :organization_services
end
