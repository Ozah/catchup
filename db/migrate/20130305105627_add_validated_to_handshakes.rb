class AddValidatedToHandshakes < ActiveRecord::Migration
  def change
    add_column :handshakes, :validated, :boolean, default: false
  end
end
