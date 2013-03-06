class AddIndexToRelationshipsContactId < ActiveRecord::Migration
  def change
    add_index :relationships, :contact_id
  end
end
