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
require "test_helper"

class WorkerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
