class AddDetailLevelToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :detail_level, :string
  end
end
