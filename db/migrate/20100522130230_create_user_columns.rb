class CreateUserColumns < ActiveRecord::Migration
  def self.up
    create_table :user_columns do |t|
      t.integer  :user_id
      t.string   :title
      t.integer  :feed_account_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_columns
  end
end
