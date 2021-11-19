class AddDefaultConstraintToNotifications < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :notifications, :integer, default: 0
  end
end
