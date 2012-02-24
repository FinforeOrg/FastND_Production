class AddFollowerAndAggregrateOnUserCompanyTabs < ActiveRecord::Migration
  def self.up
    add_column :user_company_tabs, :follower, :integer
    add_column :user_company_tabs, :is_aggregate, :boolean
  end

  def self.down
    remove_column :user_company_tabs, :follower
    remove_column :user_company_tabs, :is_aggregate
  end
end
