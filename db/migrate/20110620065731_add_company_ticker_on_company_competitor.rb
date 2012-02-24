class AddCompanyTickerOnCompanyCompetitor < ActiveRecord::Migration
  def self.up
   add_column :company_competitors, :company_ticker, :string
  end

  def self.down
    remove_column :company_competitors,:company_ticker
  end
end
