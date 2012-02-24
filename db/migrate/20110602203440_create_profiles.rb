class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :profile_category_id
      t.string :title
      t.boolean :is_public
      t.boolean :is_admin

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
