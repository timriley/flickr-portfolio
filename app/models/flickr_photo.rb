class FlickrPhoto
  def initialize(id)
    @id = id
  end
  
  def attributes
    @attributes ||= get_attributes
  end
  
  # FIXME need to allow some way for attributes to be pre-loaded during creation.
  # If these are the only attributes accessed, there is no need to load them.
  # However, if other attributes are accessed, then get_attributes is called
  # and the attributes are retrieved from flickr.
  # Idea! Will probably need to dynamically generate all of those accessor methods to
  # achieve the above.
    
  def id
    @id
  end
  def title
    attributes[:title]
  end
  def description
    attributes[:description]
  end
  def taken_at
    attributes[:taken_at]
  end
  def flickr_updated_at
    attributes[:flickr_updated_at]
  end
  def thumb_source_url
    attributes[:thumb_source_url]
  end
  def medium_source_url
    attributes[:medium_source_url]
  end
  def fullsize_source_url
    attributes[:fullsize_source_url]
  end
  
  def self.find_all_by_user_and_tag(user_nsid, tag)
    flickr.photos.search(:user_id => user_nsid, :tags => tag).collect { |photo| FlickrPhoto.new(photo.id) }
  end
  
  protected
  
  def get_attributes
    attrs = {}
    
    info = flickr.photos.getInfo(:photo_id => @id)
    urls = flickr.photos.getSizes(:photo_id => @id)
    
    attrs[:title]             = info.title
    attrs[:description]       = info.description
    attrs[:taken_at]          = info.dates.taken ? Time.parse(info.dates.taken) : nil # not everything has exif data
    attrs[:flickr_updated_at] = info.dates.lastupdate
    
    urls.each do |u|
      case u.label
      when 'Thumbnail':
        attrs[:thumb_source_url] = fix_url(u.source)
      when 'Medium':
        attrs[:medium_source_url] = fix_url(u.source)
      when 'Original':
        attrs[:fullsize_source_url] = fix_url(u.source)
      end
    end
    
    attrs
  end
  
  def fix_url(str)
    str.gsub('\\','').gsub('http: ', 'http:')
  end
end