class AddFacebookColumn < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :facebook_username, :string
    add_column :users, :facebook_uid, :integer, :limit => 8
    add_column :users, :birthday, :string
    add_column :users, :locale, :string
    add_column :users, :website, :string
    add_column :users, :about, :text
  end

  def self.down
    remove_column :users, :website
    remove_column :users, :about
    remove_column :users, :locale
    remove_column :users, :birthday
    remove_column :users, :facebook_username
    remove_column :users, :facebook_uid
    remove_column :users, :name
  end
end
