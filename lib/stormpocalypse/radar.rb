require 'httparty'

module Stormpocalypse
  class Radar
    attr_reader :location, :threats
    
    # Initialize with a location (US state abbrev)
    # TODO: support multiple location types
    def initialize(location = 'ny')
      @location = location
      scan()
    end

    # Check for new threats
    def scan
      @threats = []
      begin
        fetch_alerts.each do |alert|
          threat = Threat.new
          threat.summary = alert['summary'] # TODO: convert to sentence case
          threat.description = alert['event']
          threat.category = alert['category']
          threat.instructions = alert['instructions'] || ''
          threat.severity = alert['severity']
          threat.certainty = alert['certainty']
          threat.expires_at = DateTime.parse(alert['expires'])
          threat.locations = alert['areaDesc'].split('; ')
          @threats << threat
        end
      rescue Exception => e
        return
      end
    end

    # Query National Weather Service for alerts by state
    def fetch_alerts
      response = HTTParty.get("http://alerts.weather.gov/cap/#{@location}.atom", :format => :xml)
      return Array(response.parsed_response['feed']['entry'])
    end
  end

  class Threat
    attr_accessor :summary, :category, :severity, :certainty, :locations, :description,
      :expires_at, :instructions

    def initialize
      @summary = ''
      @description = ''
      @category = ''
      @instructions = ''
      @severity = ''
      @certainty = ''
      @expires_at = DateTime.new
      @locations = []
    end

  end
end
