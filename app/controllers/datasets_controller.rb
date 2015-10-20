# TODO: Refactor so that we can change which one is the location_column
# TODO: Refactor so that columns keep track of whether they're variable, weight, or location columns

class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy, :points]

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
    params = dataset_params
    # TODO: Iteration 2
    # TODO: Validate params
    # TODO: Consume file (validate it, condense it, write it to file, read the columns)
    
    # TODO: Create dataset creation params
    # TODO: Create dataset
    # TODO: Create columns
    # Send responses

  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    # Delete the dataset file first
    # Delete the datafile
  end


  def points
    params = point_params
    num_points = params[:num_points]
    display_val = params[:display_val]
    filter_val = params[:filter_val]
    location_type = @dataset.location_type

    points = @dataset.generate_points(1000, display_val, filter_val)
    num_points = points.size

    render json: {'points' => points, 'num_points' => num_points, 'location_type' => location_type}
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

    def point_params
      params.permit(:id, :num_points, :display_val, :filter_val)
    end

end
