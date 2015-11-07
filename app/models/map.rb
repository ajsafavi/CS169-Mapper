class Map < ActiveRecord::Base
  belongs_to :user
  belongs_to :dataset
  # TODO: Add validations

  before_create :create_shareable_url

  def create_shareable_url
  	name = self.name.gsub! " ", "_"
  	url = "#{name}_#{self.id}"
  	logger.debug("CREATING LINK")
  	self.shareable_url = url
  end
end
