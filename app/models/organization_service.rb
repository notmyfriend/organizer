# == Schema Information
#
# Table name: organization_services
#
#  id              :bigint           not null, primary key
#  organization_id :bigint           not null
#  service_id      :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class OrganizationService < ApplicationRecord
  belongs_to :organization
  belongs_to :service
  has_many :workers,    dependent: :destroy
  has_many :time_slots, dependent: :destroy
end
