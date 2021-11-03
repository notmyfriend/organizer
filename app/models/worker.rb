# == Schema Information
#
# Table name: workers
#
#  id                      :bigint           not null, primary key
#  qualification           :string
#  first_name              :string
#  last_name               :string
#  organization_service_id :bigint           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class Worker < ApplicationRecord
  belongs_to :organization_service

  validates :first_name, :last_name, :qualification, presence: true
end
