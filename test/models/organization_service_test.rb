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
require "test_helper"

class OrganizationServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
