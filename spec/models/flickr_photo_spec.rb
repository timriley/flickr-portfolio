require File.dirname(__FILE__) + '/../spec_helper'

describe FlickrPhoto do
  describe "created with a flickr id" do
    before(:each) do
      @flickr_dates       = mock('flickr dates', :taken => "2006-11-12 15: 05: 00", :lastupdate => "1207365225", :posted => "1207364225")
      @flickr_info        = mock('flickr info',            :title => 'Dinner',        :description => 'Tuna Pizza', :dates => @flickr_dates)
      @flickr_url_thumb   = mock('flickr thumb url',       :label => 'Thumbnail',     :source => 'http://flickr.com/thumbnail')
      @flickr_url_med     = mock('flickr medium url',      :label => 'Medium',        :source => 'http://flickr.com/medium')
      @flickr_url_orig    = mock('flickr original url',    :label => 'Original',      :source => 'http://flickr.com/original')
      @flickr_url_square  = mock('flickr square url',      :label => 'Square',        :source => 'http://flickr.com/square')

      @flickr_photo = FlickrPhoto.new('123')
      
      # Do a bit of leg work to make the flickr data retrievable without requiring the flickraw lib to work
      # This will allow the specs to run without requiring a network connection (which flickraw uses to setup its methods) 
      photos_container = mock('photos container')
      photos_container.stub!(:getInfo).with(:photo_id => '123').and_return(@flickr_info)
      photos_container.stub!(:getSizes).with(:photo_id => '123').and_return([@flickr_url_thumb, @flickr_url_med, @flickr_url_orig, @flickr_url_square])
      
      flickr_container = mock('flickr container')
      flickr_container.stub!(:photos).and_return(photos_container)
      
      @flickr_photo.stub!(:flickr).and_return(flickr_container)
    end
    
    it "should keep the id that was passed in the initializer" do
      @flickr_photo.id.should == '123'
    end
    
    it "should have a title matching the remote photo's title" do
      @flickr_photo.title.should == @flickr_info.title
    end
    
    it "should have a description matching the remote photo's description" do
      @flickr_photo.description.should == @flickr_info.description
    end
    
    it "should have a taken_at timestamp that matches the remote photo's taken at timestamp" do
      @flickr_photo.taken_at.should == Time.parse(@flickr_dates.taken)
    end
    
    it "should have no taken_at timestamp if the remote photo has no taken_at timestamp" do
      @flickr_dates.stub!(:taken).and_return(nil)
      @flickr_photo.taken_at.should be_nil
    end
    
    it "should have a flickr_posted_at timestamp that matches the remote photo's posted timestamp" do
      @flickr_photo.flickr_posted_at.should == Time.at(@flickr_dates.posted.to_i)
    end
    
    it "should have a flickr_updated_at timestamp that matches the remote photo's lastupdate timestamp" do
      @flickr_photo.flickr_updated_at.should == Time.at(@flickr_dates.lastupdate.to_i)
    end
    
    it "should have a thumb source url matching the remote photo's thumb source url" do
      @flickr_photo.thumb_source_url.should == @flickr_url_thumb.source
    end
    
    it "should have a medium surce url matching the remote photo's medium source url" do
      @flickr_photo.medium_source_url.should == @flickr_url_med.source
    end
    
    it "should have a fullsize source url matching the remote photo's fullsize source url" do
      @flickr_photo.fullsize_source_url.should == @flickr_url_orig.source
    end
    
    it "should have a square source url matching the remote photo's square source url" do
      @flickr_photo.square_source_url.should == @flickr_url_square.source
    end
    
    it "should have properly formatted source urls" do
      @flickr_url_thumb.stub!(:source).and_return('http: \\/\\/www.flickr.com\\/photos\\/timriley\\/469937075\\/sizes\\/m\\/')
      @flickr_photo.thumb_source_url.should == 'http://www.flickr.com/photos/timriley/469937075/sizes/m/'
    end
  end
  
  describe "when finding flickr photos by user and tag" do
    before(:each) do
      @result_1 = mock('search result 1', :id => '123')
      @result_2 = mock('search result 2', :id => '456')
      @result_3 = mock('search result 3', :id => '789')
      
      @photos_container = mock('photos container')
      @photos_container.stub!(:search).and_return([@result_1, @result_2, @result_3])      
      @flickr_container = mock('flickr container')
      @flickr_container.stub!(:photos).and_return(@photos_container)
      FlickrPhoto.stub!(:flickr).and_return(@flickr_container)
    end
    
    it "should build new flickr photo objects for each photo returned from flickr" do
      FlickrPhoto.should_receive(:new).exactly(3).times
      FlickrPhoto.find_all(:user_id => 'foo', :tag => 'bar')
    end
    
    it "should return an empty array if no photos were found" do
      @photos_container.stub!(:search).and_return([])
      FlickrPhoto.find_all(:user_id => 'foo', :tag => 'bar').should == []
    end
    
    it "should pass on the exception from flickraw if the user is unknown" do
      @photos_container.stub!(:seach).and_raise
      FlickrPhoto.find_all(:user_id => 'foo', :tag => 'bar').should raise_error
    end
    
    # it "should raise an exception if not contact flickr FIXME"
  end
end