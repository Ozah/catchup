class RemoveLocationFromMeetings < ActiveRecord::Migration
  def up
    remove_column :meetings, :location
  end

  def down
    add_column :meetings, :location, :string
  end
end
