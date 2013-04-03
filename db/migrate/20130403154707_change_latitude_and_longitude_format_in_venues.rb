class ChangeLatitudeAndLongitudeFormatInVenues < ActiveRecord::Migration
  def up
  	change_column :venues, :latitude, :float
  	change_column :venues, :longitude, :float
  end

  def down
  	change_column :venues, :latitude, :integer
  	change_column :venues, :longitude, :integer
  end
end
