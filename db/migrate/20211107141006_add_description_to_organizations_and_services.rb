class AddDescriptionToOrganizationsAndServices < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :description, :text, null: false, default: ''
    add_column :services,      :description, :text, null: false, default: ''
  end
end
