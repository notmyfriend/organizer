# == Schema Information
#
# Table name: organizations
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text             default(""), not null
#
class Organization < ApplicationRecord
  belongs_to :user, -> { where role: :owner }
  has_many :organization_services
  has_many :services, through: :organization_services
  has_many :comments, as: :commentable

  searchkick searchable: [:name], word_start: [:name]
end
