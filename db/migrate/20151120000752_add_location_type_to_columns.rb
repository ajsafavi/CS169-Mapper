class AddLocationTypeToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :location_type, :string
  end
end
