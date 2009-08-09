require File.dirname(__FILE__) + '/../spec_helper'

module PhotoSpecHelper
  def valid_photo_attributes
    {
     :flickr_id           => '325946210',
     :title               => "Last time's the charm",
     :square_source_url   => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_s.jpg',
     :thumb_source_url    => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_t.jpg',
     :medium_source_url   => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb.jpg',
     :fullsize_source_url => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_o.jpg',
     :flickr_posted_at    => 95.days.ago.beginning_of_day,
     :flickr_updated_at   => 90.days.ago.beginning_of_day
    }
  end
  def all_photo_attributes
    valid_photo_attributes.merge({
      :description        => "I hunkered down every night in the library for four weeks to write my last essay.  It was about whether J. S. Mill, for his utilitarianism, can be criticised as an advocate of individualism.",
      :taken_at           => 100.days.ago.beginning_of_day,
    })
  end
  def flickr_photo_attributes
    {
      :title                => 'Hey',
      :description          => 'Some people',
      :taken_at             => 10.days.ago.beginning_of_day,
      :flickr_posted_at     => 9.days.ago.beginning_of_day,
      :flickr_updated_at    => 8.days.ago.beginning_of_day,
      :square_source_url    => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_s.jpg',
      :thumb_source_url     => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_t.jpg',
      :medium_source_url    => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb.jpg',
      :fullsize_source_url  => 'http://farm1.static.flickr.com/134/325946210_3d6af571cb_o.jpg'
    }
  end
  def stub_attributes(obj, attrs)
    obj.stub!(:attributes).and_return(attrs)
    attrs.each_pair do |key,val|
      obj.stub!(key).and_return(val)
    end
  end
end

describe Photo, "in general" do
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
  
  it "should be active when created" do
    # @photo = Photo.new(valid_photo_attributes).save!
    @photo.should be_active
  end
end

# Struggling with style here. Not sure how to test this properly without hitting the DB.
describe Photo, "with neighbours" do
  include PhotoSpecHelper
  
  before(:each) do
    @photos = {}
    
    1.upto(5) do |i|
      @photos[i] = Photo.create!(valid_photo_attributes.with(:active => true, :flickr_id => i, :flickr_posted_at => Time.now + i.days))
    end
  end
  
  # Previous
  
  it "should have a previous photo if there is a photo with an earlier flickr posted date" do
    @photos[2].previous.should == @photos[1]
  end
  
  it "should have a previous photo only when a photo with an earlier flickr posted date is active" do
    @photos[2].update_attribute(:active, false)
    @photos[3].previous.should == @photos[1]
  end
  
  it "should have a previous photo with the closest date out of all active posted photos with earlier flickr posted dates" do
    @photos[4].previous.should == @photos[3]
  end
  
  it "should not have a previous photo if there are photos with earlier flickr posted dates but none of them are active" do
    @photos[1].update_attribute(:active, false)
    @photos[2].previous.should be_nil
  end
  
  it "should not have a previous photo if there is no photo with an earlier flickr posted date" do
    @photos[1].previous.should be_nil
  end
  
  # Next
  
  it "should have a next photo if there is a photo with a later flickr posted date" do
    @photos[4].next.should == @photos[5]
  end
  
  it "should have a next photo only when a photo with a later flickr posted date is active" do
    @photos[4].update_attribute(:active, false)
    @photos[3].next.should == @photos[5]
  end
  
  it "should have a next photo with the closest date out of all active photos with later flickr posted dates" do
    @photos[1].next.should == @photos[2]
  end
  
  it "should not have a next photo if there are photos with later flickr posted dates but none of them are active" do
    @photos[5].update_attribute(:active, false)
    @photos[4].next.should be_nil
  end
  
  it "should not have a next photo if there is no photo with a later flickr posted date" do
    @photos[5].next.should be_nil
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
  
  it "should have a flickr_posted_at timestamp matching the flickr photo's flickr_posted_at" do
    @photo.flickr_posted_at.should == @flickr_photo.flickr_posted_at
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

describe Photo, "when initializing from a flickr photo" do
  include PhotoSpecHelper
  
  before(:each) do
    @flickr_photo = mock(FlickrPhoto, :id => '12345')
    stub_attributes(@flickr_photo, flickr_photo_attributes)
    
    @photo = Photo.new_from_flickr_photo(@flickr_photo)
  end
  
  it "should be new from flickr" do
    @photo.should be_new_from_flickr
  end
  
  it_should_behave_like "a photo matching a flickr photo"
end

# describe Photo, "when updating from flickr" do

describe Photo, "when synchronising with flickr" do
  include PhotoSpecHelper
  
  # before(:each) do
  #   @photo = Photo.new(valid_photo_attributes.with(:flickr_id => '123', :flickr_updated_at => 2.days.ago.beginning_of_day))
  #       
  #   @flickr_photo = mock(FlickrPhoto, :id => '123')
  #   stub_attributes(@flickr_photo, flickr_photo_attributes.with(:flickr_updated_at => 2.days.ago.beginning_of_day))
  #   
  #   FlickrPhoto.stub!(:find_all).and_return([@flickr_photo])
  #   FlickrPhoto.stub!(:new).with(@flickr_photo.id).and_return(@flickr_photo)
  # end
  
  # describe "and there are no new photos on flickr" do
  #   it "do nothing" do
  #     @photo = mock_model(Photo, valid_photo_attributes.with(:flickr_id => '123', :flickr_updated_at => 2.days.ago.beginning_of_day))
  #     Photo.stub!(:find_by_flickr_id).and_return(@photo)
  #     
  #     @flickr_photo = mock(FlickrPhoto, :id => '123')
  #     stub_attributes(@flickr_photo, flickr_photo_attributes.with(:flickr_updated_at => 2.days.ago.beginning_of_day))
  #     FlickrPhoto.stub!(:find_all).and_return([@flickr_photo])
  #     
  #     @photo.should_receive(:save).exactly(0).times
  #     
  #     Photo.sync_with_flickr(:user_id => 'foo', :tags => 'bar')
  #   end
  # end
  
  describe "and new photos have been posted to flickr" do
    before(:each) do
      Photo.stub!(:find_by_flickr_id).and_return(nil)
    end
    
    it "should create " do
      
    end
    
  # 
  # 
  # 
  # it "should do nothing when all the photos are up to date" do
  #   Photo.stub!(:find_by_flickr_id).and_return(@photo)
  #   Photo.sync_with_flickr(:user_id => 'foo', :tag => 'bar')
  #   @photo.should_receive(:save).exactly(0).times
  # end
  # 
  # describe "and the attributes of previous photos have been updated on flickr" do
  #   before(:each) do
  #     Photo.stub!(:find_by_flickr_id).and_return(@photo)
  #     @photo.description = 'previous desc'
  #     @photo.flickr_updated_at -= 1.day
  #   end
  #   
  #   it "should update any values that are altered in the flickr photo" do
  #     @photo.stub!(:save).and_return(true)
  #     lambda {
  #       Photo.sync_with_flickr(:user_id => 'foo', :tag => 'bar')
  #     }.should change(@photo, :description).from('previous desc').to(@flickr_photo.description)
  #   end
  #   
  #   it "should save the photo" do
  #     @photo.should_receive(:save)
  #     Photo.sync_with_flickr(:user_id => 'foo', :tag => 'bar')
  #   end
  # end
  # 
  # describe "and new photos have been posted to flickr", :shared => true do
  #   before(:each) do
  #     Photo.stub!(:find).with(:all).and_return([@photo])
  #     @new_flickr_photo = mock(FlickrPhoto, :id => '456')
  #     stub_attributes(@new_flickr_photo, flickr_photo_attributes)
  #     FlickrPhoto.stub!(:find_all).and_return([@new_flickr_photo, @flickr_photo])
  #   end
  #   
  #   it "should create the new photos from flickr" do
  #     Photo.should_receive(:create_from_flickr_photo).with(@new_flickr_photo)
  #     Photo.sync_with_flickr(:user_id => 'foo', :tag => 'bar')
  #   end
  # end
  # 
  # describe "and using a different flickr tag" do
  #   it "should deactivate photos with other tags" do
  #     @old_photo = Photo.create(valid_photo_attributes.with({:tag => 'old_tag', :active => true}))
  #     Photo.sync_with_flickr(:user_id => 'foo', :tag => 'new_tag')
  #     @old_photo.reload
  #     @old_photo.should_not be_active
  #   end
  # 
  #   # it_should_behave_like "and new photos have been posted to flickr"
  # end
end