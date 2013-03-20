class ChangeEmailUniqueness < ActiveRecord::Migration
	def change  
		remove_index :users, :column => :email
  	add_index :users, :email, unique: false
  end
end
