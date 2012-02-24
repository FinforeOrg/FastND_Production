class DropLinkedinTokensAndRemovePasswordInFeedAccounts < ActiveRecord::Migration
  def self.up
    drop_table :linkedin_tokens
    remove_column :feed_accounts, :password
  end

  def self.down
    create_table :linkedin_tokens do |t|
      t.integer :user_id
      t.string  :token
      t.string  :secret
      t.timestamps
    end
    add_column :feed_accounts, :password, :string
  end
end
