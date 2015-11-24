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

	def datasets
		@public_datasets = Dataset.where(is_public: true)
		@our_datasets = @user.datasets
		ans = Set.new
		
		@public_datasets.each do |dataset|
			ans.add(dataset)
		end

		@our_datasets.each do |dataset|
			ans.add(dataset)
		end

		render json: ans
	end

private

	def set_user
      @user = User.find(params[:id])
    end

	def user_params
		params.permit("id")
	end

end
