class CreateHandshakes < ActiveRecord::Migration
  def change
    create_table :handshakes do |t|
      t.integer :user_id
      t.integer :meeting_id

      t.timestamps
    end

    add_index :handshakes, :user_id
    add_index :handshakes, :meeting_id
  end
end
