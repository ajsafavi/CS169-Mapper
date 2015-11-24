class UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy, :points, :column_suggestions, :maps, :datasets]

	def show

		if !(@user.eql? current_user)
			render json: {"errors" => ["unauthorized!!!"], "current_user" => current_user, "user" => @user}, status: :unauthorized
		end

		@datasets = @user.datasets
	end

	def maps
		render json:  @user.maps
	end

private

	def set_user
      @user = User.find(params[:id])
    end

	def user_params
		params.permit("id")
	end

end
