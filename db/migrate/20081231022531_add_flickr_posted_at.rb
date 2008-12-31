class AddFlickrPostedAt < ActiveRecord::Migration
  def self.up
    add_column :photos, :flickr_posted_at, :datetime
  end

  def self.down
    remove_column :photos, :flickr_posted_at
  end
end
