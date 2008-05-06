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
  
  def update_attributes_from_flickr
    self.attributes.merge!(Photo.flickr_photo_attributes(self.flickr_id))
  end
  
  def self.flickr_photos_by_user_and_tag(nsid, tag)
    flickr.photos.search(:user_id => nsid, :tags => tag, :extras => 'last_update').collect { |photo| [photo.id, photo.lastupdate] }
  end
    
  def self.flickr_photo_attributes(flickr_id)
    attrs = {}
    
    info = flickr.photos.getInfo(:photo_id => flickr_id)
    urls = flickr.photos.getSizes(:photo_id => flickr_id)
    
    attrs[:flickr_photo_id]   = info.id
    attrs[:title]             = info.title
    attrs[:description]       = info.description
    attrs[:taken_at]          = Time.parse(info.dates.taken) if info.dates.taken # not everything has exif data
    attrs[:flickr_updated_at] = info.dates.lastupdate
    
    urls.each do |u|
      case u.label
      when 'Thumbnail':
        attrs[:thumb_source_url] = u.source.gsub('\\','').gsub('http: ', 'http:')
      when 'Medium':
        attrs[:medium_source_url] = u.source.gsub('\\','').gsub('http: ', 'http:')
      when 'Original':
        attrs[:fullsize_source_url] = u.source.gsub('\\','').gsub('http: ', 'http:')
      end
    end
    
    attrs
  end
  
  def self.new_from_flickr(flickr_id)
    photo = Photo.new
    photo.attributes = Photo.flickr_photo_attributes(flickr_id)
    photo
  end
  
  def self.create_from_flickr(flickr_id)   
    photo = Photo.new_from_flickr(flickr_id)
    photo.save
  end
  
  def self.flickr_sync_by_user_and_tag(nsid, tag)
    flickr_photos = Photo.flickr_photos_by_user_and_tag(nsid, tag)
    
    photos = Photo.find(:all)
    
    # sort all of the current photos by flickr id
    photos_by_flickr_id = {}
    photos.each do |photo|
      photos_by_flickr_id[photo.flickr_id] = photo
    end
    
    flickr_photos.each do |flickr_photo|
      if !photos_by_flickr_id.keys.include?(flickr_photo[0])
        # If the photo does not exist among the ones from the db, create it.
        Photo.create_from_flickr_id(flickr_photo[0])
      elsif photos_by_flickr_id[flickr_photo[0]].flickr_updated_at.to_i < flickr_photo[1].to_i
        # If we've imported the photo before, update it if it has been updated on flickr
        photo = photos_by_flickr_id[flickr_photo[0]]
        photo.update_attributes_from_flickr(flickr_photo[0])
        photo.save
      end
    end
  end
end
