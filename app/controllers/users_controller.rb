class UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy, :points, :column_suggestions]


	def show
		# TODO: Authenticate
		params = user_params

	end

	def maps

	end

private
	
	def user_params
		params.permit("id")
	end

end
