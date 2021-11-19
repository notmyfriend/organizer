class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type
      t.boolean :deleted, null: false, default: 'false'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
