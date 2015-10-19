class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy]

  # GET /datasets
  # GET /datasets.json
  def index
    @datasets = Dataset.all
  end

  # GET /datasets/1
  # GET /datasets/1.json
  def show
  end

  # GET /datasets/new
  def new
    @dataset = Dataset.new
  end

  # GET /datasets/1/edit
  def edit
  end

  # POST /datasets
  # POST /datasets.json
  def create

    # Validate params
    # Save file somewhere
    # Read columns
    # Create dataset creation params
    # Create dataset
    # Create columns
    # Send responses

  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    # Delete the dataset file first
    # Delete the datafile
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dataset_params
      params.permit(:id, :name, :owner, :location_column, :location_type, :weight_column, :datafile)
    end

end
