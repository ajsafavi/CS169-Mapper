class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :filepath
      t.string :location_column
      t.string :weight_column
      t.string :location_type
      t.integer :num_rows

      t.timestamps null: false
    end
  end
end
