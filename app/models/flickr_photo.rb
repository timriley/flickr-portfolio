class FlickrPhoto
  
  attr_accessor :id
  
  def initialize(id)
    @id = id
  end
  
  def attributes
    @attributes ||= get_attributes
  end
  
  def attributes=(attrs)
    # FIXME there must be a better way to do this.
    @attributes = attrs
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
  def updated_at
    attributes[:updated_at]
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
  
  # FIXME this will have to return an array of FlickrPhoto objects now.
  def self.find_all_by_user_and_tag(user_nsid, tag)
    flickr.photos.search(:user_id => user_nsid, :tags => tag, :extras => 'last_update').collect { |photo| [photo.id, photo.lastupdate] }
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