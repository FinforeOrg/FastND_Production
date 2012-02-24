class AddPasswordUserAccounts < ActiveRecord::Migration
  def self.up
    add_column :feed_accounts, :password, :string
  end

  def self.down
    remove_column :feed_accounts, :password
  end
end
