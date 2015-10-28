 class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @okay = @user.save

    respond_to do |format|
      format.html { 
        if !@okay
          # It's not chill! Show some error
        else
          # Redirect to viewing that map?
        end
      } # TODO: Render a "You're not supposed to be here"
      
      format.json {
        if @okay
          redirect_to @user, format: :json
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      }

    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    params = user_params.except!(:id)
    @user.update(params)

    @okay = @user.valid?

    respond_to do |format|
      format.html { 
        if !@okay
          # It's not chill! Show some error
        else
          # Redirect to viewing that map?
        end
      } # TODO: Render a "You're not supposed to be here"
      
      format.json {
        if @okay
          redirect_to @user, format: :json
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      }

    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    head :no_content 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:id, :first_name, :last_name, :email)
    end
end
