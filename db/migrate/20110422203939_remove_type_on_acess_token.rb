class RemoveTypeOnAcessToken < ActiveRecord::Migration
  def self.up
    rename_column :access_tokens,:type,:category
    rename_column :access_tokens,:key, :long_key
  end

  def self.down
    rename_column :access_tokens,:category,:type
    rename_column :access_tokens,:long_key,:key
  end
end
