require 'httparty'
require 'pp'

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
      feed = HTTParty.get("http://alerts.weather.gov/cap/#{@location}.atom", :format => :xml)['feed']

      pp feed

      if feed['entry'].kind_of?(Array)
        feed.each do |item|
          process_threat(item)
        end
      else
        process_threat(feed['entry'])
      end
    end

    # Query National Weather Service for alerts by state

    def process_threat(item)
      return if item['title'] == "There are no active watches, warnings or advisories"

      alert = HTTParty.get(item['id'], :format => :xml)['alert']['info']
      threat = Threat.new
      threat.event = alert['event']
      threat.summary = alert['headline']
      threat.description = alert['description'] # TODO: convert to sentence case
      threat.category = alert['category']
      threat.instructions = alert['instructions'] || ''
      threat.severity = alert['severity']
      threat.certainty = alert['certainty']
      threat.expires_at = DateTime.parse(alert['expires'])
      threat.locations = alert['area']['areaDesc'].split('; ')
      @threats << threat
    end
  end

  class Threat
    attr_accessor :event, :summary, :category, :severity, :certainty, :locations, 
      :description, :expires_at, :instructions

    def initialize
      @event = ''
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
