class AddIsPublicToDatasets < ActiveRecord::Migration
  def change
    add_column :datasets, :is_public, :boolean
  end
end
