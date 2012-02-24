class CreateCompanyCompetitors < ActiveRecord::Migration
  def self.up
    create_table :company_competitors do |t|
      t.integer :feed_info_id
      t.text :keyword

      t.timestamps
    end
  end

  def self.down
    drop_table :company_competitors
  end
end
