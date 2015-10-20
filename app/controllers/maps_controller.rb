class MapsController < ApplicationController
  before_action :set_map, only: [:show, :edit, :update, :destroy]

  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.all
  end

  # GET /maps/1
  # GET /maps/1.json
  def show
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
    # If they have a shareable link, verify that it is acceptable
    @map = Map.new(map_params)
  end

  # PATCH/PUT /maps/1
  # PATCH/PUT /maps/1.json
  def update
    # If they have a shareable link, verify that it is acceptable
    # If they change from an existing shareable link, make sure that the old link is freed up

  end

  def shareable
    # Find map it belongs to and redirect to that
  end

  # DELETE /maps/1
  # DELETE /maps/1.json
  def destroy
    # If they have a shareable link, make sure it gets deleted as well
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
end
