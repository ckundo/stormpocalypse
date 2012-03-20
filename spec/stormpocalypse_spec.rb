#require 'webmock/rspec'
require 'stormpocalypse'

describe Stormpocalypse::Radar do
  before do
    #stub_request(:get, "http://alerts.weather.gov/cap/us.atom").to_return(
      #lambda { |request| File.new("tmp/#{request.uri.host.to_s}.txt" ) }
    #)
    @location = 'ny'
    @radar = Stormpocalypse::Radar.new(@location)
  end

  it 'should have an array of threats' do
    @radar.threats.should be_an_instance_of Array
  end
  
  it 'should have a location' do
    @radar.location.should eql(@location)
  end

  context 'an individual threat' do
    before do
      @threat = @radar.threats.first
    end
    
    # Tornado Watch, Hurricane Watch, etc
    it 'should have a description' do
      @threat.description.should be_an_instance_of String
      @threat.description.should_not be_empty
    end

    it 'should have a summary' do
      @threat.summary.should be_an_instance_of String
      @threat.summary.should_not be_empty
    end

    it 'should have instructions' do
      @threat.instructions.should be_an_instance_of String
    end

    it 'should have an expiration time' do
      @threat.expires_at.should be_an_instance_of DateTime
    end

    it 'should have a category from a predefined set' do
      category = @threat.category
      %w(geo met safety security rescue fire health env transport infra cbrne other).include?(category.downcase).should be_true
    end

    it 'should have a degree of severity from a predefined set' do
      severity = @threat.severity
      %w(extreme severe moderate minor unknown).include?(severity.downcase).should be_true
    end
    
    it 'should have a level of certainty from a predefined set' do
      certainty = @threat.certainty
      %w(observed expected likely unlikely unknown).include?(certainty.downcase).should be_true
    end

    # NWS provides counties as locations
    it 'should have an array of affected locations' do
      locations = @threat.locations
      locations.should be_an_instance_of Array
      locations.should_not be_empty
    end
  end

end
