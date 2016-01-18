class CreateParks < ActiveRecord::Migration
  def change
    create_table :parks do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.float :area_square
      t.float :area_hectare
      t.string :service_at_str
      t.date :service_at

      t.timestamps null: false
    end
  end
end
