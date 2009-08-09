require 'rubygems'
require 'sinatra'
require 'haml'

API_KEY = 'c6dd75f50c46aeb23918d4dd857220fe'
USER_ID = '24905543@N00'
USER_URL = 'timriley'
FEATURE_TAG = 'study' # should be 'feature'

# From http://github.com/toolmantim/toolmantim
require 'net/http'
require 'hpricot'
require 'uri'
require 'delegate'

class Flickr
  def recent
    call("search", "per_page" => 9)/:photo
  end
  def featured
    call("search", "tags" => FEATURE_TAG, "per_page" => 500)/:photo
  end
  def photo(id)
    call("getInfo", "photo_id" => id).search(:photo).first
  end
  def sizes(photo)
    call("getSizes", "photo_id" => photo[:id])/:size
  end
  def neighbours(photo)
    featured = featured()
    [photo, featured].flatten.each {|p| def p.==(other); self[:id] == other[:id]; end }
    index = featured.index(photo)
    index && [index != 0 && featured[index-1], featured[index+1]]
  end
  def call(method, params)
    res = Net::HTTP.get(URI.parse("http://api.flickr.com/services/rest/?method=flickr.photos.#{method}&api_key=#{API_KEY}&user_id=#{USER_ID}#{params.collect{|k,v|"&#{k}=#{v}"}}"))
    return Hpricot.XML(res) if !res.include?('stat="fail"')
  end
end

class PrefetchedFlickr < Flickr
  def initialize
    @featured_thread = create_featured_fetcher_thread
  end
  def featured_with_prefetch # override
    STDERR.puts "Returning cached flickr photos"
    @featured_thread["photos"]
  end
  alias :featured_without_prefetch :featured
  alias :featured :featured_with_prefetch

  private
  
  def create_featured_fetcher_thread
    Thread.new do
      Thread.current["photos"] = []
      while true do
        Thread.current["photos"] = featured_without_prefetch
        STDERR.puts "Fetched #{Thread.current["photos"].length} photos"
        sleep(900)
      end
    end
  end
end

$flickr = PrefetchedFlickr.new

helpers do
  def flickr_src(photo, size=nil)
    "http://farm#{photo[:farm]}.static.flickr.com/#{photo[:server]}/#{photo[:id]}_#{photo[:secret]}#{size && "_#{size}"}.jpg"
  end
  def flickr_url(photo)
    "http://www.flickr.com/photos/#{USER_URL}/#{photo[:id]}/"
  end
  def flickr_square(photo)
    %(<img src="#{flickr_src(photo, "s")}" width="75" height="75" />)
  end
  def photo_path(photo)
    "/photos/#{photo[:id]}"
  end
  def pluralize(number, singular)
    case number.to_i
    when 0
      "No #{singular}s"
    when 1
      "1 #{singular}"
    else
      "#{number} #{singular}s"
    end
  end
end

get '/' do
  @photo = $flickr.featured[0]
  @sizes = $flickr.sizes(@photo)
  haml :photo
end

get '/archive' do
  @recent_photos = $flickr.recent
  @feature_photos = $flickr.featured
  haml :index
end

get '/photos/:id' do
  @photo = $flickr.photo(params[:id]) || raise(Sinatra::NotFound)
  @sizes = $flickr.sizes(@photo)
  @prev_photo, @next_photo = $flickr.neighbours(@photo)
  haml :photo
end

# TODO
# not_found do
#   content_type 'text/html'
#   haml :not_found
# end
# 
# error do
#   @error = request.env['sinatra.error'].to_s
#   content_type 'text/html'
#   haml :error
# end unless Sinatra::Application.environment == :development