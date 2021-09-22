# == Schema Information
#
# Table name: time_slots
#
#  id                      :bigint           not null, primary key
#  organization_service_id :bigint           not null
#  start_time              :time             not null
#  end_time                :time             not null
#  status                  :integer          default("vacant"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
require "test_helper"

class TimeSlotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
