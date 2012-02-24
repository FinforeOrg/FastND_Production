class CreateProfileCategories < ActiveRecord::Migration
  def self.up
    create_table :profile_categories do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_categories
  end
end
