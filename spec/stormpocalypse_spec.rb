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
    it "should have a summary" do
      summary = @radar.threats.first.summary
      summary.should be_an_instance_of String
      summary.should_not be_nil
    end
  end

end
