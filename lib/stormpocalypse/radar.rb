require 'httparty'
require 'pp' # for debugging

module Stormpocalypse
  class Radar
    attr_reader :location, :threats
    
    # Initialize with a location (US state abbrev)
    # TODO: support multiple location types
    def initialize(location)
      @location = location
      scan()
    end

    # Check for new threats
    def scan
      @threats = []
      fetch_alerts.each do |alert|
        threat = Threat.new
        threat.summary = alert['summary'] # TODO: convert to sentence case
        threat.category = alert['category']
        threat.severity = alert['severity']
        threat.locations = alert['areaDesc'].split('; ')
        @threats << threat
      end
      pp @threats
    end

    # Query National Weather Service for alerts by state
    def fetch_alerts
      response = HTTParty.get("http://alerts.weather.gov/cap/#{@location}.atom", :format => :xml)
      return Array(response.parsed_response['feed']['entry'])
    end
  end

  class Threat
    attr_accessor :summary, :category, :severity, :locations

    def initialize
      @summary = 'unknown'
      @category = 'met'
      @severity = 'unknown'
      @locations = []
    end

  end
end
