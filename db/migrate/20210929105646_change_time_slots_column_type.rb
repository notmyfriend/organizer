class ChangeTimeSlotsColumnType < ActiveRecord::Migration[6.1]
  def change
    rename_column :time_slots, :start_time, :start_time_old
    rename_column :time_slots, :end_time, :end_time_old

    add_column :time_slots, :start_time, :datetime, null: false
    add_column :time_slots, :end_time, :datetime, null: false

    remove_column :time_slots, :start_time_old
    remove_column :time_slots, :end_time_old
  end
end
