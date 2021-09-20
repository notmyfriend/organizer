class CreateWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      t.string :qualification
      t.string :first_name
      t.string :last_name
      t.references :organization_service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
