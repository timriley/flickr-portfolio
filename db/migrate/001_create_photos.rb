class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string    :title
      t.text      :description
      t.string    :flickr_id
      t.string    :thumb_source_url
      t.string    :medium_source_url
      t.string    :fullsize_source_url
      t.boolean   :active, :default => true
      t.datetime  :taken_at
      t.datetime  :flickr_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
