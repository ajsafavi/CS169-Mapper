class UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy, :points, :column_suggestions]

	def show
		if not @user.eql? current_user
			render json: {"errors" => ["unauthorized!!!"], "current_user" => current_user, "user" => @user}, status: :unauthorized
		end
	end

	def auth_example

	end

	def maps

	end

private

	def set_user
      @user = User.find(params[:id])
    end

	def user_params
		params.permit("id")
	end

end
