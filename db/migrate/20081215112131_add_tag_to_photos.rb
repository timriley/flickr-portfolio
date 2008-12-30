class AddTagToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :tag, :string
    add_index :photos, :tag
  end

  def self.down
    remove_index :photos, :tag
    remove_column :photos, :tag
  end
end
