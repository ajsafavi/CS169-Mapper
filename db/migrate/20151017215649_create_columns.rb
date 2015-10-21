class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.references :dataset, index: true, foreign_key: true
      t.string :name
      t.string :column_type
      t.string :null_value

      t.timestamps null: false
    end
  end
end
