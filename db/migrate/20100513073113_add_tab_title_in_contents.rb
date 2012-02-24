class AddTabTitleInContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :tab_title, :string
  end

  def self.down
    remove_column :contents, :tab_title
  end
end
