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
end