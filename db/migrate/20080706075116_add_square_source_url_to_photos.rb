class AddSquareSourceUrlToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :square_source_url, :string
  end

  def self.down
    remove_column :photos, :square_source_url
  end
end
