require File.dirname(__FILE__) + '/../spec_helper'

module PhotoSpecHelper
  def valid_photo_attributes
    {
     :flickr_id => '325946210',
     :title => "Last time's the charm",
     :thumb_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_t.jpg',
     :medium_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb.jpg',
     :fullsize_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_o.jpg',
    }
  end
  def valid_flickr_photo_attributes
    {
      :title => 'Hey',
      :description => 'Some people',
      :taken_at => 10.days.ago,
      :updated_at => 9.days.ago,
      :thumb_source_url => 'http://thumb.com',
      :medium_source_url => 'http://medium.com',
      :fullsize_source_url => 'http://full.com'
    }
  end
end

describe "a photo matching a flickr photo", :shared => true do
  it "should have a flickr_id matching the flickr photo's id" do
    @photo.flickr_id.should == @flickr_photo.id
  end
  
  it "should have a title matching the flickr photo's title" do
    @photo.title.should == @flickr_photo.title
  end
  
  it "should have a description matching the flickr photo's description" do
    @photo.description.should == @flickr_photo.description
  end
  
  it "should have an updated_at timestamp matching the flickr photo's updated_at" do
    @photo.flickr_updated_at.should == @flickr_photo.updated_at
  end
  
  it "should have a thumbnail source url matching the flickr photo's thumbnail source url" do
    @photo.thumb_source_url.should == @flickr_photo.thumb_source_url
  end
  
  it "should have a medium source url matching the flickr photo's medium source url" do
    @photo.medium_source_url.should == @flickr_photo.medium_source_url
  end
  
  it "should have a fullsize source url matching the flickr photo's fullsize source url" do
    @photo.fullsize_source_url.should == @flickr_photo.fullsize_source_url
  end
end

describe Photo do
  include PhotoSpecHelper
    
  before(:each) do
    @photo = Photo.new
  end
  
  it "should be valid with flickr photo id, thumb, medium, and fullsize source urls, and title" do
    @photo.attributes = valid_photo_attributes
    @photo.should be_valid
  end
  
  it "should be invalid without flickr photo id" do
    @photo.attributes = valid_photo_attributes.except(:flickr_id)
    @photo.should_not be_valid
  end
  
  it "should be invalid without a thumbnail photo source url" do
    @photo.attributes = valid_photo_attributes.except(:thumb_source_url)
    @photo.should_not be_valid
  end
    
  it "should be invalid without a medium photo source url" do
    @photo.attributes = valid_photo_attributes.except(:medium_source_url)
    @photo.should_not be_valid
  end
  
  it "should be invalid without a fullsize photo source url" do
    @photo.attributes = valid_photo_attributes.except(:fullsize_source_url)
    @photo.should_not be_valid
  end

  it "should be invalid without title" do
    @photo.attributes = valid_photo_attributes.except(:title)
    @photo.should_not be_valid
    @photo.should have(1).errors
  end
      
  describe "when created" do
    before(:each) do
      @photo.attributes = valid_photo_attributes
      @photo.save!
    end
    
    it "should be active when created" do
      @photo.should be_active    
    end
  end
  
  describe "when creating from a flickr photo" do
    before(:each) do
      # @flickr_photo = mock(FlickrPhoto, :title => 'Hey', :description => 'Some people',
      #   :taken_at => 10.days.ago, :updated_at => 9.days.ago, :thumb_source_url => 'http://thumb.com',
      #   :medium_source_url => 'http://medium.com', :fullsize_source_url => 'http://full.com')
      @flickr_photo = mock(FlickrPhoto, :id => '12345', :attributes => valid_flickr_photo_attributes)
      valid_flickr_photo_attributes.each_pair do |key,val|
        @flickr_photo.stub!(key, val)
      end
    end
    
    describe "and initialializing" do
      before(:each) do
        @photo = Photo.new_from_flickr(@flickr_photo)
      end      
      
      it_should_behave_like "a photo matching a flickr photo"
    end
    
    describe "and creating" do
      before(:each) do
        @photo = Photo.create_from_flickr(@flickr_photo)
      end
      
      it_should_behave_like "a photo matching a flickr photo"
    end
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
  #   
  #   describe "import_by_user_and_tag" do
  #     it "should raise an argument exception if tag is not passed" do
  #       
  #     end
  #     
  #     it "should raise an argument exception if user NSID is not passed" do
  #       
  #     end
  #     
  #     it "should do nothing if all the returned photos have already been imported" do
  #       
  #     end
  #     
  #     it "should create photo objects for any photos that are not already imported" do
  #       
  #     end
  #   end
  # end
end