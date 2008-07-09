require File.dirname(__FILE__) + '/../spec_helper'
require 'stringio'

module SettingsSpecHelper
  def settings_hash
    { 'production' =>   { 'fred'    => 'fred value production',
                          'barney'  => 'barney value production' },
      'development' =>  { 'fred'    => 'fred value development',
                          'barney'  => 'barney value development' },
      'test'        =>  { 'fred'    => 'fred value test',
                          'barney'  => 'barney value test' }}
  end
end

describe Settings do
  include SettingsSpecHelper
  
  before(:each) do
    @settings = Settings.instance
    YAML.stub!(:load_file).and_return(settings_hash)
  end
  
  # TODO test for validations here
  
  it "should return the value of a setting" do
    @settings.fred.should == settings_hash[Rails.env]['fred']
  end
  
  it "should return nil for a setting that does not exist" do
    @settings.betty.should be_nil
  end
  
  it "should only return the value of a setting for the current rails environment" do
    Rails.stub!(:env).and_return('production')
    @settings.barney.should == settings_hash['production']['barney']
  end
  
  # FIXME this won't work until we have the settings_hash contain enough entries for the object to be valid
  # it "should save the settings to a yaml file" do
  #   File.stub!(:open).and_return(true)
  #   @settings.save.should == true
  # end
  
  it "should not load the settings data from a file if no requests for settings are made"
  
  it "should load the settings data from a file when a request for a setting is made"
end
