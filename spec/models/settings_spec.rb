require File.dirname(__FILE__) + '/../spec_helper'

describe Settings do
  before(:each) do
    @settings = Settings.new
  end

  it "should be valid" do
    @settings.should be_valid
  end
end
