class CreateKeywordColumns < ActiveRecord::Migration
  def self.up
    create_table :keyword_columns do |t|
      t.integer :user_id
      t.string :keyword
      t.boolean :is_aggregate
      t.integer :follower
      t.timestamps
    end
  end

  def self.down
    drop_table :keyword_columns
  end
end
