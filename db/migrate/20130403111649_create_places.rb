class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :user_id
      t.integer :venue_id

      t.timestamps
    end
  end
end
