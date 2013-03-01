class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :infos, :user_id
  end
end
