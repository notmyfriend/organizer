# == Schema Information
#
# Table name: reservations
#
#  id           :bigint           not null, primary key
#  user_id      :bigint           not null
#  time_slot_id :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
