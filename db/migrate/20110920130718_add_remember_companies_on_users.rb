class AddRememberCompaniesOnUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:remember_companies,:string
  end

  def self.down
    remove_column :users, :remember_companies
  end
end
