require 'stormpocalypse'

describe Stormpocalypse::Radar do
  before do
    @location = 'us'
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
    
    it 'should have a category' do
      summary = @threat.summary
      summary.should be_an_instance_of String
      summary.should_not be_empty
    end

    it 'should have a category from a predefined set' do
      category = @threat.category
      %w(geo met safety security rescue fire health env transport infra cbrne other).include?(category.downcase).should be_true
    end

    it 'should have a degree of severity from a predefined set' do
      @severity = @threat.severity
      %w(extreme severe moderate minor unknown).include?(@severity.downcase).should be_true
    end

    # NWS provides counties as locations
    it 'should have an array of affected locations' do
      locations = @threat.locations
      locations.should be_an_instance_of Array
      locations.should_not be_empty
    end
  end

end
