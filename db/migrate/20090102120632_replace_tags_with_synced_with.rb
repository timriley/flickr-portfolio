class ReplaceTagsWithSyncedWith < ActiveRecord::Migration
  def self.up
    remove_column :photos, :tags
    add_column :photos, :synced_with, :string
    add_index :photos, :synced_with
  end

  def self.down
    remove_index :photos, :synced_with
    remove_column :photos, :synced_with
    add_column :photos, :tags, :string
  end
end