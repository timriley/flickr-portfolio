class Photo < ActiveRecord::Base
    
  validates_uniqueness_of :flickr_photo_id
  validates_presence_of :flickr_photo_id, :message => "can't be blank"
  validates_presence_of :thumb_source_url, :message => "can't be blank"
  validates_presence_of :medium_source_url, :message => "can't be blank"
  validates_presence_of :fullsize_source_url, :message => "can't be blank"
  validates_presence_of :title, :message => "can't be blank"
  
  def hidden?
    !self.active?
  end
    
  def self.new_from_flickr_photo(flickr_photo)
    Photo.new(flickr_photo.attributes)
  end
  
  def self.create_from_flickr_photo(flickr_photo)   
    Photo.create(flickr_photo.attributes)
  end
  
  def update_from_flickr!
    self.attributes.merge!(FlickrPhoto.new(self.flickr_id).attributes)
  end
  
  # def self.flickr_photos_by_user_and_tag(user_nsid, tag)
    
  # def self.flickr_photo_attributes(flickr_id)
  
  # FIXME THIS NEEDS UPDATING TO WORK WITH FlickrPhoto
  def self.flickr_sync_by_user_and_tag(nsid, tag)
    flickr_photos = Photo.flickr_photos_by_user_and_tag(nsid, tag)
    local_photos  = Photo.find(:all)
    
    # sort all of the current photos by flickr id
    local_photos_by_flickr_id = {}
    local_photos.each do |photo|
      photos_by_flickr_id[photo.flickr_id] = photo
    end
    
    flickr_photos.each do |photo_info|
      if !local_photos_by_flickr_id[photo_info[0]]
        # if the photo does not exist locally, create it.
        Photo.create_from_flickr_id(photo_info[0])
      elsif local_photos_by_flickr_id[photo_info[0]].flickr_updated_at.to_i < photo_info[1].to_i
        # if we've imported the photo before, but it has been since updated on flickr, update it locally.
        local_photo = local_photos_by_flickr_id[photo_info[0]]
        local_photo.update_attributes_from_flickr(photo_info[0])
        local_photo.save
      end
    end
  end  
end
