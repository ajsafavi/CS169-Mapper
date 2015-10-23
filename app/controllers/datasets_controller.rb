# TODO: Refactor so that we can change which one is the location_column
# TODO: Refactor so that columns keep track of whether they're variable, weight, or location columns

class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy, :points, :column_suggestions]
  skip_before_action :verify_authenticity_token

  # GET /datasets
  # GET /datasets.json
  def index
    @datasets = Dataset.all
    render json: @datasets
  end

  # GET /datasets/1
  # GET /datasets/1.json
  def show
    @to_render = @dataset.as_json
    @to_render["columns"] = @dataset.columns
    render json: @to_render

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
    create_params = Hash.new

    create_params[:name] = params[:name]
    create_params[:filepath] = (Rails.root + "/datasets/fake.csv").to_s
    create_params[:location_column] = params[:location_column]
    create_params[:location_type] = params[:location_type]
    create_params[:weight_column] = params[:weight_column]
    create_params[:num_rows] = 1000
    create_params[:name] = params[:user]

    @dataset = Dataset.new(create_params)
    if @dataset.save
      redirect_to @dataset
    else
      render json: @dataset.errors, status: :unprocessable_entity
    end

    # TODO: Iteration 2
    # TODO: Validate params
    # TODO: Consume file (validate it, condense it, write it to file, read the columns)
    
    # TODO: Create dataset creation params
    # TODO: Create dataset
    # TODO: Create columns
    # Send responses


  end

  def update
    params = dataset_edit_params.except!(:id)

    @dataset.update(params)

    config.log_level = :debug 

    if @dataset.valid?
      logger.debug(@dataset.inspect)
      redirect_to @dataset
    else
      render json: @dataset.errors, status: :unprocessable_entity
    end
  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    # Delete the dataset file first
    # Delete the datafile
    @dataset.destroy_file!
    @dataset.destroy
    head :no_content
  end


  def points
    params = point_params
    num_points = params[:num_points].to_i
    display_val = params[:display_val]
    filter_val = params[:filter_val]
    location_type = @dataset.location_type
    config.log_level = :debug 
    logger.debug("PARAMS: #{params.inspect}")
    logger.debug("filter_val : #{filter_val}")
    logger.debug("ABOUT TO RUN")
    @points = @dataset.generate_points(num_points, display_val, filter_val)
    logger.debug("NUMBER OF POINTS : #{@points.size}")
    num_points = @points.size

    render json: {'points' => @points, 'num_points' => num_points, 'location_type' => location_type}
  end

  def column_suggestions
    ans = Array.new
    guess = column_params[:partial_name]
    @dataset.columns.each do |column|
      if column.name.starts_with?(guess)
        ans.push({'name' => column.name, 'id' => column.id})
      end
    end
    render json: ans
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

    def dataset_edit_params
      params.permit(:id, :name, :owner, :location_column, :location_type, :weight_column, :filepath)
    end

    def point_params
      params.permit(:id, :num_points, :display_val, :filter_val)
    end

    def column_params
      params.permit(:id, :partial_name)
    end

end
