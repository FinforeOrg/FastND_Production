class RemoveBooleanOnProfiles < ActiveRecord::Migration
  def self.up
    remove_column :profiles,:is_public
    remove_column :profiles,:is_admin
    add_column :profiles,:is_private,:boolean, :default=>true
  end

  def self.down
    add_column :profiles, :is_public, :boolean
    add_column :profiles, :is_admin, :boolean, :default=>true
    remove_column :profiles,:is_private
  end
end
