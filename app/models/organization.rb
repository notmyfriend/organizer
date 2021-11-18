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
  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  belongs_to :user, -> { where role: :owner }

  has_many :organization_services, dependent: :destroy
  has_many :services, through: :organization_services
  has_many :comments, as: :commentable

  searchkick searchable: [:name], word_start: [:name]
end
