class CreateNoticeboardRoles < ActiveRecord::Migration
  def self.up
    create_table :noticeboard_roles do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :noticeboard_roles
  end
end
