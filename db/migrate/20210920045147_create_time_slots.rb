class CreateTimeSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :time_slots do |t|
      t.references :organization_service, null: false, foreign_key: true
      t.time :start_time,                 null: false
      t.time :end_time,                   null: false
      t.integer :status,                  null: false, default: 0

      t.timestamps
    end
  end
end
