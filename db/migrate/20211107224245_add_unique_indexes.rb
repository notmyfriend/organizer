class AddUniqueIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :organizations, [:name], unique: true
    add_index :organization_services, [:organization_id, :service_id], unique: true
  end
end
