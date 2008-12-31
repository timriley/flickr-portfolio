class Photo < ActiveRecord::Base

  named_scope :active,  :conditions => { :active => true }
  named_scope :with_tag, lambda { |tag| { :conditions => ['tag = ?', tag] } }
  
  acts_as_audited

  validates_uniqueness_of :flickr_id
  validates_presence_of   :flickr_id,           :message => "can't be blank"
  validates_presence_of   :title,               :message => "can't be blank"
  validates_presence_of   :square_source_url,   :message => "can't be blank"
  validates_presence_of   :thumb_source_url,    :message => "can't be blank"
  validates_presence_of   :medium_source_url,   :message => "can't be blank"
  validates_presence_of   :fullsize_source_url, :message => "can't be blank"
  validates_presence_of   :flickr_posted_at,    :message => "can't be blank" # this is used for photo ordering
  validates_presence_of   :flickr_updated_at,   :message => "can't be blank" # needed for syncing
  
  liquid_methods  :id,
                  :title,
                  :square_source_url,
                  :thumb_source_url,
                  :medium_source_url,
                  :fullsize_source_url,
                  :previous,
                  :next
  
  def previous
    @previous_photo ||= Photo.active.first(:order => 'flickr_posted_at DESC, id DESC', :conditions => ['flickr_posted_at < ?', flickr_posted_at])
  end
  
  def next
    @next_photo ||= Photo.active.first(:order => 'flickr_posted_at ASC, id ASC', :conditions => ['flickr_posted_at > ?', flickr_posted_at])
  end
  
  def update_from_flickr
    self.attributes = self.attributes.merge(FlickrPhoto.new(self.flickr_id).attributes)
  end
  
  def update_from_flickr_photo(flickr_photo)
    if flickr_updated_at.to_i < flickr_photo.flickr_updated_at.to_i
      self.attributes = self.attributes.merge(flickr_photo.attributes)
    end
  end
  
  def self.new_from_flickr_photo(flickr_photo)
    Photo.new do |photo|
      photo.flickr_id           = flickr_photo.id                   # Basic info
      photo.title               = flickr_photo.title
      photo.description         = flickr_photo.description
      photo.square_source_url   = flickr_photo.square_source_url    # URLs
      photo.thumb_source_url    = flickr_photo.thumb_source_url
      photo.medium_source_url   = flickr_photo.medium_source_url
      photo.fullsize_source_url = flickr_photo.fullsize_source_url
      photo.taken_at            = flickr_photo.taken_at             # Dates
      photo.flickr_posted_at    = flickr_photo.flickr_posted_at
      photo.flickr_updated_at   = flickr_photo.flickr_updated_at 
    end
  end
  
  def self.create_from_flickr_photo(flickr_photo)
    returning Photo.new_from_flickr_photo(flickr_photo) do |photo|
      photo.save
    end
  end
  
  # Only allow the following options, :user_id => user_id, :tag => tag
  def self.sync_with_flickr(options = {})
    if options.empty?
      # TODO return an error because we need at least a :user or a :tag
    end
    
    transaction do
      if options[:tag]
        update_all('active = false', ['tag != ?', options[:tag]])
      end
    
      search_options = {}
      search_options[:user_id]  = options[:user_id] unless options[:user_id].blank?
      search_options[:tags]     = options[:tag]     unless options[:tag].blank?
    
      flickr_photos = FlickrPhoto.find_all(search_options)
      local_photos  = Photo.all
    
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
          Photo.create_from_flickr_photo(flickr_photo)
        end
      end
    end
  end  
end