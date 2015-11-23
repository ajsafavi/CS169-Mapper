class RemoveTypedColumnsFromDatasets < ActiveRecord::Migration
  def change
    remove_column :datasets, :weight_column, :string
    remove_column :datasets, :location_column, :string
    remove_column :datasets, :location_type, :string
  end
end
