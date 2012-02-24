class CreatePriceTickers < ActiveRecord::Migration
  def self.up
    create_table :price_tickers do |t|
      t.integer :feed_info_id
      t.string :ticker
      t.timestamps
    end
  end

  def self.down
    drop_table :price_tickers
  end
end
