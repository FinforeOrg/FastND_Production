class CreateLinkedinTokens < ActiveRecord::Migration
  def self.up
    create_table :linkedin_tokens do |t|
      t.integer :user_id
      t.string  :token
      t.string  :secret
      t.timestamps
    end
  end

  def self.down
    drop_table :linkedin_tokens
  end
end
