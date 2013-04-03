class ChangeFoursquareIdFormatInVenues < ActiveRecord::Migration
  def up
  	change_column :venues, :foursquare_id, :string
  end

  def down
  	change_column :venues, :foursquare_id, :integer
  end
end
