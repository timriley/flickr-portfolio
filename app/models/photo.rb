class Photo < ActiveRecord::Base
  
  acts_as_audited

  validates_uniqueness_of :flickr_id
  validates_presence_of   :flickr_id,           :message => "can't be blank"
  validates_presence_of   :square_source_url,   :message => "can't be blank"
  validates_presence_of   :thumb_source_url,    :message => "can't be blank"
  validates_presence_of   :medium_source_url,   :message => "can't be blank"
  validates_presence_of   :fullsize_source_url, :message => "can't be blank"
  validates_presence_of   :title,               :message => "can't be blank"
  
  liquid_methods  :id,
                  :title,
                  :square_source_url,
                  :thumb_source_url,
                  :medium_source_url,
                  :fullsize_source_url,
                  :previous,
                  :next
  
  def update_from_flickr
    self.attributes = self.attributes.merge(FlickrPhoto.new(self.flickr_id).attributes)
  end
  
  def previous
    @previous_photo ||= Photo.find(:first, :order => 'created_at DESC', :conditions => ['created_at < ?', created_at])
  end
  
  def next
    @next_photo ||= Photo.find(:first, :order => 'created_at ASC', :conditions => ['created_at > ?', created_at])
  end
  
  def self.new_from_flickr(flickr_photo)
    Photo.new do |photo|
      photo.flickr_id           = flickr_photo.id
      photo.title               = flickr_photo.title
      photo.description         = flickr_photo.description
      photo.taken_at            = flickr_photo.taken_at
      photo.flickr_updated_at   = flickr_photo.flickr_updated_at
      photo.square_source_url   = flickr_photo.square_source_url
      photo.thumb_source_url    = flickr_photo.thumb_source_url
      photo.medium_source_url   = flickr_photo.medium_source_url
      photo.fullsize_source_url = flickr_photo.fullsize_source_url
    end
  end
  
  def self.create_from_flickr(flickr_photo)
    photo = Photo.new_from_flickr(flickr_photo)
    photo.save
    photo
  end

  # def self.flickr_photos_by_user_and_tag(user_nsid, tag)
    
  # def self.flickr_photo_attributes(flickr_id)
  
  def self.sync_with_flickr_by_user_and_tag(nsid, tag)
    flickr_photos = FlickrPhoto.find_all_by_user_and_tag(nsid, tag)
    local_photos  = Photo.find(:all)
    
    # sort all of the current photos by flickr id
    local_photos_by_flickr_id = {}
    local_photos.each do |photo|
      local_photos_by_flickr_id[photo.flickr_id] = photo
    end
    
    flickr_photos.each do |flickr_photo|
      if local_photo = local_photos_by_flickr_id[flickr_photo.id]
        # we've imported the photo before, update it from flickr if it is stale
        if local_photo.flickr_updated_at.to_i < flickr_photo.flickr_updated_at.to_i
          local_photo.update_from_flickr
          # local_photo.attributes.merge(flickr_photo.attributes)
          local_photo.save
        end
      else
        # if the photo does not exist locally, create it.
        Photo.create_from_flickr(flickr_photo)
      end
    end
  end  
end