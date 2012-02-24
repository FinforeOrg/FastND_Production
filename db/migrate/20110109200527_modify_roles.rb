class ModifyRoles < ActiveRecord::Migration
  def self.up
    rename_column :roles, :title, :name
    add_column :roles, :authorizable_type, :string, :limit => 40
    add_column :roles, :authorizable_id, :integer
    add_index :roles, :name
    add_index :roles, :authorizable_id
    add_index :roles, :authorizable_type
    add_index :roles, [:name, :authorizable_id, :authorizable_type], :unique => true
  end

  def self.down
    remove_index :roles, [:name, :authorizable_id, :authorizable_type]
    remove_index :roles, :authorizable_type
    remove_index :roles, :authorizable_id
    remove_index :roles, :name
    drop_table :roles
  end
end
