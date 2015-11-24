# TODO: Refactor so that we can change which one is the location_column
# TODO: Refactor so that columns keep track of whether they're variable, weight, or location columns

class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy, :points, :column_suggestions]
  skip_before_action :verify_authenticity_token

  # GET /datasets
  # GET /datasets.json
  def index
    ans = Set.new(Dataset.where(is_public: true))
    if current_user
      others = current_user.datasets
      others.each do |dataset|
        ans.add(dataset)
      end
    end

    render json: ans
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

    params[:owner] = params[:owner].to_i
    if (current_user.nil? or current_user.id != params[:owner])
      # logger.debug "CURRENTLY_LOGGED_IN: #{current_user.id.class}, OWNER: #{params[:owner].class}"
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    else
      create_params = Hash.new
      create_params[:name] = params[:name]
      create_params[:num_rows] = 1000
      create_params[:user_id] = params[:owner]
      create_params[:filepath] = params[:filepath]

      @dataset = Dataset.new(create_params)

      @okay = @dataset.save
      logger.debug @dataset.errors
      if not @okay
        render json: @dataset.errors, status: :unprocessable_entity
      end

      ajax_upload = params[:datafile].is_a?(String)
      filedata = nil
      if ajax_upload
        filedata =  request.body.read
      else
        logger.debug "DATAFILE: #{params[:datafile]}"
        filedata = params[:datafile].read
      end   

      # Create columns
      columns = params[:columns]
      columns.each do |column_params|
        column_params[:dataset_id] = @dataset.id
        column = Column.new(column_params)
        if not column.save
          render json: column.errors, status: :unprocessable_entity
        end
      end

      @dataset.consume_raw_file(filedata)

      redirect_to @dataset, format: :json
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
      logger.debug "CURRENT_USER: #{current_user.id}, Owner: #{@dataset.user_id}"
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    else

      params = point_params
      num_points = params[:num_points].to_i
      display_val = params[:display_val].strip

      if params[:detail_level]
        detail_level = params[:detail_level].strip
      else
        detail_level = "STATE"
      end

      filter_val = "#{params[:filter_val]}".strip

      if filter_val.nil? or filter_val.length == 0
        filter_val = nil
      end

      config.log_level = :debug 
      @points = @dataset.generate_points(num_points, display_val, filter_val, detail_level)
      # logger.debug @points
      num_points = @points.size

      render json: {'points' => @points, 'num_points' => num_points}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dataset_params
      column_params = [:name, :detail_level, :column_type, :location_type, :description, :friendly_name, :null_value]
      params.permit(:id, :name, :owner, :datafile, {columns: column_params})
    end

    def dataset_edit_params
      # params.permit(:id, :name, :owner, :location_column, :location_type, :weight_column, :filepath)
    end

    def point_params
      params.permit(:id, :num_points, :display_val, :filter_val, :detail_level)
    end

    def column_params
      params.permit(:id, :partial_name)
    end

end
