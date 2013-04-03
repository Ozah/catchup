class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
    	t.integer  :foursquare_id
      t.string 	 :name
      t.text 		 :location
      t.text		 :icon

      t.timestamps
    end
    add_index :venues, :foursquare_id
  end
end
