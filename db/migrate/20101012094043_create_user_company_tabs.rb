class CreateUserCompanyTabs < ActiveRecord::Migration
  def self.up
    create_table :user_company_tabs do |t|
      t.integer :user_id
      t.integer :feed_info_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_company_tabs
  end
end
