class MainController < ApplicationController
  def index
    @parks = Park.all
    @hash = Gmaps4rails.build_markers(@parks) do |park, marker|
      marker.lat park.latitude
      marker.lng park.longitude
      marker.infowindow park.address
      marker.json({title: park.name})
    end

    @polylines = []
    @parks.each_with_index do |row, i|
      next_row = @parks[i + 1]
      if next_row.nil?
        next_row = @parks.first
      end


      hash = [
        {lat: row.latitude, lng: row.longitude},
        {lat: next_row.latitude, lng: next_row.longitude}
      ]
      @polylines << hash
    end
  end
end
