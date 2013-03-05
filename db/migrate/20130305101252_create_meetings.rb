class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
