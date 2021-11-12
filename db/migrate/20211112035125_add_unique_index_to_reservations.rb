class AddUniqueIndexToReservations < ActiveRecord::Migration[6.1]
  def change
    add_index :reservations, [:user_id, :time_slot_id], unique: true
  end
end
