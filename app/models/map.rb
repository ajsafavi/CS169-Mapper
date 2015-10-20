class Map < ActiveRecord::Base
  belongs_to :user
  belongs_to :dataset
  # TODO: Add validations
end
