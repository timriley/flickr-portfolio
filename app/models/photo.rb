class Photo < ActiveRecord::Base

  named_scope :active,    :conditions => { :active => true }
  named_scope :inactive,  :conditions => { :active => false }
  
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
  
  def to_param
    flickr_id
  end
  
  def to_liquid
    { 'id'                  => self.flickr_id,
      'title'               => self.title,
      'square_source_url'   => self.square_source_url,
      'thumb_source_url'    => self.thumb_source_url,
      'medium_source_url'   => self.medium_source_url,
      'fullsize_source_url' => self.fullsize_source_url,
      'previous'            => self.previous,
      'next'                => self.next }
  end
  
  def self.latest
    active.first(:order => 'flickr_posted_at DESC, id DESC')
  end
  
  def previous
    @previous_photo ||= Photo.active.first(:order => 'flickr_posted_at DESC, id DESC', :conditions => ['flickr_posted_at < ?', flickr_posted_at])
  end
  
  def next
    @next_photo ||= Photo.active.first(:order => 'flickr_posted_at ASC, id ASC', :conditions => ['flickr_posted_at > ?', flickr_posted_at])
  end
  
  def new_from_flickr?
    !synced_with?
  end
  
  def update_from_flickr
    merge_attributes_from_flickr_photo(FlickrPhoto.new(flickr_id))
  end
  
  def merge_attributes_from_flickr_photo(flickr_photo)
    self.flickr_id = flickr_photo.id
    self.attributes = self.attributes.merge(flickr_photo.attributes)        
  end
  
  def update_from_flickr_photo(flickr_photo)
    if flickr_updated_at.to_i < flickr_photo.flickr_updated_at.to_i
      merge_attributes_from_flickr_photo(flickr_photo)
    end
  end
  
  def self.new_from_flickr_photo(flickr_photo)
    Photo.new do |photo|
      photo.merge_attributes_from_flickr_photo(flickr_photo)
    end
  end
  
  def self.create_from_flickr_photo(flickr_photo)
    returning Photo.new_from_flickr_photo(flickr_photo) do |photo|
      photo.save
    end
  end
  
  def self.create_or_update_from_flickr_photo(flickr_photo)
    if photo = find_by_flickr_id(flickr_photo.id)
      photo.update_from_flickr_photo(flickr_photo)
      photo.save if photo.changed?
    else
      create_from_flickr_photo(flickr_photo)
    end
  end
  
  # Use these options - {:user_id => 'user_id', :tags => 'tags'}
  def self.sync_with_flickr(options)
    transaction do
      delete_for_sync(options)
      
      FlickrPhoto.find_all(options).each do |p|
        photo = create_or_update_from_flickr_photo(p)
        photo.update_attribute(:synced_with, sync_options_to_s(options)) if photo.new_from_flickr?
      end
    end
  end
  
  private
  
  def self.delete_for_sync(options)
    delete_all(["synced_with != ?", sync_options_to_s(options)])
  end
  
  def self.sync_options_to_s(options)
    "#{options[:user_id]}|#{options[:tags]}"
  end
end