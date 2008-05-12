require File.dirname(__FILE__) + '/../spec_helper'

module PhotoSpecHelper
  def valid_photo_attributes
    {
     :flickr_id => '325946210',
     :title => "Last time's the charm",
     :thumb_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_t.jpg',
     :medium_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb.jpg',
     :fullsize_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_o.jpg'
    }
  end
  def all_photo_attributes
    {
      :description => "I hunkered down every night in the library for four weeks to write my last essay.  It was about wheether J. S. Mill, for his utilitarianism, can be criticised as an advocate of individualism.",
      :taken_at => 100.days.ago,
      :flickr_updated_at => 99.days.ago
    }.merge(valid_photo_attributes)
  end
  def flickr_photo_attributes
    {
      :title => 'Hey',
      :description => 'Some people',
      :taken_at => 10.days.ago,
      :flickr_updated_at => 9.days.ago,
      :thumb_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_t.jpg',
      :medium_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb.jpg',
      :fullsize_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_o.jpg'
    }
  end
  def stub_attributes(obj, attrs)
    obj.stub!(:attributes).and_return(attrs)
    attrs.each_pair do |key,val|
      obj.stub!(key).and_return(val)
    end
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
  
  it "should have a flickr_updated_at timestamp matching the flickr photo's updated_at" do
    @photo.flickr_updated_at.should == @flickr_photo.flickr_updated_at
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
      @flickr_photo = mock(FlickrPhoto, :id => '12345')
      stub_attributes(@flickr_photo, flickr_photo_attributes)
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
    
  describe "when updating from flickr" do
    before(:each) do
      # setup_attributes(@photo, all_photo_attributes.with(:flickr_id => '12345'))
      @photo.attributes = all_photo_attributes.with(:flickr_id => '12345')
      @flickr_photo = mock(FlickrPhoto, :id => '12345')
      stub_attributes(@flickr_photo, flickr_photo_attributes)
    end
    
    describe "before the update" do
      it "should have a flickr_id matching the flickr photo's id" do
        @photo.flickr_id.should == @flickr_photo.id
      end
      
      it "should have a title that does not match the flickr photo's title" do
        @photo.title.should_not == @flickr_photo.title
      end
      
      it "should have a description that does not match the flickr photo's description" do
        @photo.description.should_not == @flickr_photo.description
      end
      
      it "should have source urls that match the flickr photo's source urls" do
        @photo.thumb_source_url.should    == @flickr_photo.thumb_source_url
        @photo.medium_source_url.should   == @flickr_photo.medium_source_url
        @photo.fullsize_source_url.should == @flickr_photo.fullsize_source_url
      end
    end
    
    describe "after the update" do
      before(:each) do
        FlickrPhoto.stub!(:new).and_return(@flickr_photo)
        @photo.update_from_flickr!
      end
      
      it_should_behave_like "a photo matching a flickr photo"
    end
  end
end