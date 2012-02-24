class ModifyCompanyCompetitors < ActiveRecord::Migration
  def self.up
    add_column :company_competitors, :competitor_ticker, :text
    add_column :company_competitors, :company_keyword, :text
    add_column :company_competitors, :broadcast_keyword, :text
    add_column :company_competitors, :finance_keyword, :text
    add_column :company_competitors, :bing_keyword, :text
    add_column :company_competitors, :blog_keyword, :text
  end

  def self.down
    remove_column :company_competitors, :competitor_ticker
    remove_column :company_competitors, :company_keyword
    remove_column :company_competitors, :broadcast_keyword
    remove_column :company_competitors, :finance_keyword
    remove_column :company_competitors, :bing_keyword
    remove_column :company_competitors, :blog_keyword
  end
end
