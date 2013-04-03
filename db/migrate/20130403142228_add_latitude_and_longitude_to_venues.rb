class AddLatitudeAndLongitudeToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :latitude, :integer
    add_column :venues, :longitude, :integer
  end
end
