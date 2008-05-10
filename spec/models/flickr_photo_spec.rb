require File.dirname(__FILE__) + '/../spec_helper'

describe FlickrPhoto do
  
end

# 
# describe "class method" do
#   
#   describe "new_from_flickr" do
#     
#     describe "when photo found" do
#     
#       before(:each) do
#         @flickr_photo = mock(FlickRaw::Response)
#         @flickr_photo.stub!(:id).and_return('325946210')
#         @flickr_photo.stub!(:title).and_return("Last time's the charm")
#         @flickr_photo.stub!(:description).and_return("I hunkered down every night in the library for four weeks to write my last essay.")
#         flickr_photo_dates = mock(FlickRaw::Response)
#         flickr_photo_dates.stub!(:taken).and_return("2006-11-12 15: 05: 00")
#         @flickr_photo.stub!(:dates).and_return(flickr_photo_dates)
#       
#         @thumb_url = mock(FlickRaw::Response)
#         @thumb_url.stub!(:label).and_return('Thumbnail')
#         @thumb_url.stub!(:source).and_return("http://farm1.static.flickr.com/134/325946210_3d6af571cb_t.jpg")
#         @medium_url = mock(FlickRaw::Response)
#         @medium_url.stub!(:label).and_return('Medium')
#         @medium_url.stub!(:source).and_return("http://farm1.static.flickr.com/134/325946210_3d6af571cb.jpg")
#         @fullsize_url = mock(FlickRaw::Response)
#         @fullsize_url.stub!(:label).and_return('Original')
#         @fullsize_url.stub!(:source).and_return("http://farm1.static.flickr.com/134/325946210_3d6af571cb_o.jpg")        
#       
#         @flickr_photo_urls = [@thumb_url, @medium_url, @fullsize_url]
#       end
#     
#       it "should create a photo object with title matching the flickr photo's title" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo)
#         flickr.photos.should_receive(:getSizes).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo_urls)
#         Photo.new_from_flickr(@flickr_photo.id).title.should == @flickr_photo.title
#       end
#     
#       it "should create a photo object with description matching the flickr photo's description" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo)
#         flickr.photos.should_receive(:getSizes).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo_urls)
#         Photo.new_from_flickr(@flickr_photo.id).description.should == @flickr_photo.description
#       end
#     
#       it "should have a taken_at date that matches the response from flickr" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo)
#         flickr.photos.should_receive(:getSizes).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo_urls)
#         Photo.new_from_flickr(@flickr_photo.id).taken_at.to_s.should == Time.parse(@flickr_photo.dates.taken).to_s
#       end
#       
#       it "should have a thumb source url that matches the flickr photo" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo)
#         flickr.photos.should_receive(:getSizes).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo_urls)
#         Photo.new_from_flickr(@flickr_photo.id).thumb_source_url.should == @thumb_url.source
#       end
#       
#       it "should have a medium source url that matches the flickr photo" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo)
#         flickr.photos.should_receive(:getSizes).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo_urls)
#         Photo.new_from_flickr(@flickr_photo.id).medium_source_url.should == @medium_url.source
#       end
#       
#       it "should have a thumb source url that matches the flickr photo" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo)
#         flickr.photos.should_receive(:getSizes).with(:photo_id => @flickr_photo.id).and_return(@flickr_photo_urls)
#         Photo.new_from_flickr(@flickr_photo.id).fullsize_source_url.should == @fullsize_url.source
#       end
#       
#     end
#     
#     
#     describe "when photo not found" do
#       it "should raise a photo not found exception" do
#         flickr.photos.should_receive(:getInfo).with(:photo_id => 'badid').and_raise(FlickRaw::FailedResponse.new('Photo "badid" not found (invalid ID)', '1', 'flickr.photos.getInfo'))
#         lambda{
#           Photo.new_from_flickr('badid')
#         }.should raise_error(FlickRaw::FailedResponse)
#       end
#     end
#   end
#   
#   describe "search_flickr_by_user_and_tag" do
#     it "should return an empty array if no photos are found with the tag" do
#       flickr.photos.should_receive(:search).with(:user_id => '24905543@N00', :tags => 'study').and_return([])
#       Photo.search_flickr_by_user_and_tag('24905543@N00', 'study').should == []
#     end
#     
#     it "should return an array of ids for the user's photos with the tag" do
#       flickr_photo_1 = mock(FlickRaw::Response)
#       flickr_photo_1.stub!(:id).and_return('325946210')
#       flickr_photo_2 = mock(FlickRaw::Response)
#       flickr_photo_2.stub!(:id).and_return('282010363')
#       flickr.photos.should_receive(:search).with(:user_id => '24905543@N00', :tags => 'study').and_return([flickr_photo_1, flickr_photo_2])
#       Photo.search_flickr_by_user_and_tag('24905543@N00', 'study').should == [flickr_photo_1.id, flickr_photo_2.id]
#     end
#   end