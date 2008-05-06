require 'rubygems'
require 'flickraw'

FlickRaw.api_key = 'c6dd75f50c46aeb23918d4dd857220fe'
FlickRaw.shared_secret = '5f1baac675b760c3'

#uid = flickr.people.findByUsername(:username => 'Tim Riley 澳大利亚').nsid
uid = flickr.urls.lookupUser(:url => 'http://www.flickr.com/photos/timriley').id

# my nsid is 24905543@N00

photo = flickr.photos.search(:user_id => uid, :tags => 'study').first


#p photo

info = flickr.photos.getInfo(:photo_id => photo.id)
p info


sizes = flickr.photos.getSizes(:photo_id => photo.id)
p sizes

p info.dates.taken

#p photo.id
#p info.title
#p info.description
#p sizes.collect { |s| "#{s.label} - #{s.source}" }
