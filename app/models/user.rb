class User < ActiveRecord::Base
	has_many :datasets
	has_many :maps
	
end
