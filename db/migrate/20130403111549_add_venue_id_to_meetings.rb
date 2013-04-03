class AddVenueIdToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :venue_id, :integer
  end
end
