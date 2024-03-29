class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false, :force => true do |t|
      t.integer  :user_id
      t.integer  :role_id
      t.timestamps
    end
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
    add_index :roles_users, [:user_id, :role_id], :unique => true
    #add_foreign_key :roles_users, :users
    #add_foreign_key :roles_users, :roles
  end

  def self.down
    #drop_foreign_key :roles_users, :users
    #drop_foreign_key :roles_users, :roles
    remove_index :roles_users, :user_id
    remove_index :roles_users, :role_id
    remove_index :roles_users, [:user_id, :role_id]
    drop_table :roles_users
  end
end
