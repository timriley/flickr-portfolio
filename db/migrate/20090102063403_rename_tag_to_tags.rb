class RenameTagToTags < ActiveRecord::Migration
  def self.up
    rename_column :photos, :tag, :tags
  end

  def self.down
    rename_column :photos, :tags, :tag
  end
end
