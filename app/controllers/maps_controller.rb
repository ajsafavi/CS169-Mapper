# TODO: Add support for both JSON and HTML

class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy, :points]

  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1
  # GET /maps/1.json
  def show
    respond_to do |format|
      format.html { } # TODO: Render the map page!
      format.json {
        render json: @map
      }
    end
    
  end

  # GET /maps/new
  def new
    @map = Map.new
  end

  # GET /maps/1/edit
  def edit
  end

  # POST /maps
  # POST /maps.json
  def create
    # TODO: If they have a shareable link, verify that it is acceptable
    @errors = Array.new
    params = map_params
    @map = Map.create(map_params)

    @okay = @map.valid?
    if @okay
      redirect_to @map, format: :json
    else
      render json: @map.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /maps/1
  # PATCH/PUT /maps/1.json
  def update
    # If they have a shareable link, verify that it is acceptable
    # If they change from an existing shareable link, make sure that the old link is freed up
    @errors = Array.new
    params = map_params.except!(:id)

    if !@map.is_example? and (current_user.nil? or current_user.id != @map.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    end

    @map.update(params)

    @okay = @map.valid?
    
    if @okay
      redirect_to @map, format: :json
    else
      render json: @map.errors, status: :unprocessable_entity
    end
    
  end

  def shareable
    # TODO: Find map it belongs to and redirect to that
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    # If they have a shareable link, make sure it gets deleted as well
    if !@map.is_example? and (current_user.nil? or current_user.id != @map.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    end
    @map.destroy 
    head :no_content
  end

  def points
    params = point_params
    @dataset = @map.dataset

    if !@map.is_example? and (current_user.nil? or current_user.id != @map.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    end

    if !@dataset.is_public? and (current_user.nil? or current_user.id != @dataset.user_id)
      render json: {"errors" => ["Not authorized!"]}, status: :unauthorized
    end

    num_points = params[:num_points].to_i
    display_val = params[:display_val]
    filter_val = params[:filter_val]
    location_type = @dataset.location_type
    @points = @dataset.generate_points(num_points, display_val, filter_val)
    num_points = @points.size

    render json: {'points' => @points, 'num_points' => num_points, 'location_type' => location_type}

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = Map.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.permit(:id, :name, :owner, :dataset, :display_variable, :filter_variable, :styling)
    end

    def point_params
      params.permit(:id, :num_points, :display_val, :filter_val)
    end
end
