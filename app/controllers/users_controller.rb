class UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy, :points, :column_suggestions]

	def show
		logger.debug current_user

		if @user.eql? current_user
			render json: @resource
		else
			render json: {"errors":["unauthorized!!!"]}, status: :unauthorized
		end
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
