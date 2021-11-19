# == Schema Information
#
# Table name: services
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text             default(""), not null
#
class Service < ApplicationRecord
  has_many :organization_services, dependent: :restrict_with_error
  has_many :organizations, through: :organization_services

  searchkick searchable: [:name], word_start: [:name]
end
