# TODO: Refactor so that we can change which one is the location_column
# TODO: Refactor so that columns keep track of whether they're variable, weight, or location columns

class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy, :points, :column_suggestions]
  skip_before_action :verify_authenticity_token

  # GET /datasets
  # GET /datasets.json
  def index
    @datasets = Dataset.all
    respond_to do |format|
      format.html { }
      format.json { render json: @datasets }
    end
  end

  # GET /datasets/1
  # GET /datasets/1.json
  def show
    @columns =  @dataset.columns
    @to_render = @dataset.as_json
    @to_render["columns"] = @columns
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

    if (current_user.nil? or current_user.id != params[:owner].to_i)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    else
      create_params = Hash.new
      create_params[:name] = params[:name]
      create_params[:filepath] = (Rails.root + "/datasets/fake.csv").to_s
      create_params[:location_column] = params[:location_column]
      create_params[:location_type] = params[:location_type]
      create_params[:weight_column] = params[:weight_column]
      create_params[:num_rows] = 1000
      create_params[:user_id] = params[:owner]

      @dataset = Dataset.new(create_params)
      @okay = @dataset.save
      logger.debug @dataset.errors
      if @okay
        redirect_to @dataset, format: :json
      else
        render json: @dataset.errors, status: :unprocessable_entity
      end

    end

  end

  def update

    if (current_user.nil? or current_user.id != @dataset.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    else

      params = dataset_edit_params.except!(:id)

      @dataset.update(params)

      @okay = @dataset.valid?

      if @okay
        redirect_to @dataset, format: :json
      else
        render json: @dataset.errors, status: :unprocessable_entity
      end
    end

  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy

    if (current_user.nil? or current_user.id != @dataset.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    end
    # Delete the dataset file first
    # Delete the datafile
    @dataset.destroy_file!
    @dataset.destroy
    head :no_content
  end


  def points
    if !@dataset.is_public? and (current_user.nil? or current_user.id != @dataset.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    else

      params = point_params
      num_points = params[:num_points].to_i
      display_val = params[:display_val]
      filter_val = params[:filter_val]
      if filter_val.nil? or filter_val.length == 0
        filter_val = nil
      end
      location_type = @dataset.location_type
      config.log_level = :debug 
      @points = @dataset.generate_points(num_points, display_val, filter_val)
      num_points = @points.size

      render json: {'points' => @points, 'num_points' => num_points, 'location_type' => location_type}
    end
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
