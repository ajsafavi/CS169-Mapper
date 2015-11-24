class UserInputDataController < ApplicationController
  before_action :set_user_input_datum, only: [:show, :edit, :update, :destroy]

  # GET /user_input_data
  # GET /user_input_data.json
  def index
    @user_input_data = UserInputDatum.all
  end

  # GET /user_input_data/1
  # GET /user_input_data/1.json
  def show
  end

  # GET /user_input_data/new
  def new
    @user_input_datum = UserInputDatum.new
  end

  # GET /user_input_data/1/edit
  def edit
  end

  # POST /user_input_data
  # POST /user_input_data.json
  def create
    @user_input_datum = UserInputDatum.new(user_input_datum_params)

    respond_to do |format|
      if @user_input_datum.save
        format.html { redirect_to @user_input_datum, notice: 'User input datum was successfully created.' }
        format.json { render :show, status: :created, location: @user_input_datum }
      else
        format.html { render :new }
        format.json { render json: @user_input_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_input_data/1
  # PATCH/PUT /user_input_data/1.json
  def update
    respond_to do |format|
      if @user_input_datum.update(user_input_datum_params)
        format.html { redirect_to @user_input_datum, notice: 'User input datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_input_datum }
      else
        format.html { render :edit }
        format.json { render json: @user_input_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_input_data/1
  # DELETE /user_input_data/1.json
  def destroy
    @user_input_datum.destroy
    respond_to do |format|
      format.html { redirect_to user_input_data_url, notice: 'User input datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_input_datum
      @user_input_datum = UserInputDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_input_datum_params
      params[:user_input_datum]
    end
end
