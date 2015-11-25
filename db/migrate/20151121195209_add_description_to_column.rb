class AddDescriptionToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :description, :string
    add_column :columns, :friendly_name, :string
  end
end
