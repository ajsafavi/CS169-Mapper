class AddIsExampleToMap < ActiveRecord::Migration
  def change
    add_column :maps, :is_example, :boolean
  end
end
