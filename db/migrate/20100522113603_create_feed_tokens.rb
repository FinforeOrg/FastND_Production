class CreateFeedTokens < ActiveRecord::Migration
  def self.up
    create_table :feed_tokens do |t|
      t.integer :user_id
      t.integer :feed_account_id
      t.string  :token
      t.string  :secret
      t.string  :token_preauth
      t.string  :secret_preauth
      t.string  :url_oauth
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_tokens
  end
end
