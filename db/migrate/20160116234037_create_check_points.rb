class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
