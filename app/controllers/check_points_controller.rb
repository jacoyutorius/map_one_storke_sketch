class CheckPointsController < ApplicationController
  before_action :set_check_point, only: [:show, :edit, :update, :destroy]

  # GET /check_points
  # GET /check_points.json
  def index
    @check_points = CheckPoint.all

    @polylines = []
    @check_points.each_with_index do |row, i|
      next_row = @check_points[i + 1]
      if next_row.nil?
        next_row = @check_points.first
      end

      hash = [
        {lat: row.latitude, lng: row.longitude},
        {lat: next_row.latitude, lng: next_row.longitude}
      ]
      @polylines << hash
    end
  end

  # GET /check_points/1
  # GET /check_points/1.json
  def show
    @hash = Gmaps4rails.build_markers(@check_point) do |check_point, marker|
      marker.lat check_point.latitude
      marker.lng check_point.longitude
      marker.infowindow check_point.address
      marker.json({title: check_point.address})
    end
  end

  # GET /check_points/new
  def new
    @check_point = CheckPoint.new
  end

  # GET /check_points/1/edit
  def edit
  end

  # POST /check_points
  # POST /check_points.json
  def create
    @check_point = CheckPoint.new(check_point_params)
    @check_point.latitude = check_point_params[:latitude].to_f
    @check_point.longitude = check_point_params[:longitude].to_f

# binding.pry
p @check_point
    respond_to do |format|
      if @check_point.save
        format.html { redirect_to @check_point, notice: 'Check point was successfully created.' }
        format.json { render :show, status: :created, location: @check_point }
      else
        format.html { render :new }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /check_points/1
  # PATCH/PUT /check_points/1.json
  def update
    respond_to do |format|
      if @check_point.update(check_point_params)
        format.html { redirect_to @check_point, notice: 'Check point was successfully updated.' }
        format.json { render :show, status: :ok, location: @check_point }
      else
        format.html { render :edit }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /check_points/1
  # DELETE /check_points/1.json
  def destroy
    @check_point.destroy
    respond_to do |format|
      format.html { redirect_to check_points_url, notice: 'Check point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_check_point
      @check_point = CheckPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def check_point_params
      params.require(:check_point).permit(:address, :latitude, :longitude)
    end
end
