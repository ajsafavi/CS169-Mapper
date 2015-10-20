class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.references :user, index: true, foreign_key: true
      t.references :dataset, index: true, foreign_key: true
      t.string :name
      t.string :display_variable
      t.string :filter_variable
      t.string :shareable_url, index: true
      t.string :styling
      t.timestamps null: false
    end
  end
end
