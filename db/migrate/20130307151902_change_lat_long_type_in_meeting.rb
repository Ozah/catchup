class ChangeLatLongTypeInMeeting < ActiveRecord::Migration
  def change
    change_column :meetings, :latitude, :float
    change_column :meetings, :longitude, :float
  end
end
