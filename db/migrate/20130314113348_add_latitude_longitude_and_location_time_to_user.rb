class AddLatitudeLongitudeAndLocationTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :location_time, :datetime
  end
end
