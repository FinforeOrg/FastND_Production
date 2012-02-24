class AddRememberColumnsOnUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_columns, :string
  end

  def self.down
    remove_column :users, :remember_columns
  end
end
