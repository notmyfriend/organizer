class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[6.1]
  def change
    add_index :subscriptions, [:user_id, :time_slot_id], unique: true
  end
end
