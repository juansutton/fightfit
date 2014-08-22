class AddFirstNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
  end
   def self.down
    add_column :users, :first_name, :string
end
end
