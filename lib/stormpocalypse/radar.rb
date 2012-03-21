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
      entry = HTTParty.get("http://alerts.weather.gov/cap/#{@location}.atom", 
                           :format => :xml).fetch('feed').fetch('entry')

      if entry.kind_of?(Array)
        entry.each do |item|
          begin
            process_threat(item)
          rescue Exception => e
            next
          end
        end
      else
        begin
          process_threat(entry)
        rescue Exception => e
          return
        end
      end
    end

    def process_threat(item)
      return nil if item.fetch('summary').eql?("There are no active watches, warnings or advisories")

      alert = HTTParty.get(item.fetch('id'), :format => :xml).fetch('alert').fetch('info')
      threat = Threat.new(alert)
      @threats << threat
    end
  end

  class Threat
    attr_accessor :event, :summary, :category, :severity, :certainty, :locations, 
      :description, :expires_at, :instructions
    
    def initialize(alert)
      @event = alert['event']
      @summary = alert['headline']
      @description = alert['description']
      @category = alert['category']
      @instructions = alert['instructions'] || ''
      @severity = alert['severity']
      @certainty = alert['certainty']
      @expires_at = DateTime.parse(alert['expires'])
      @locations = alert['area']['areaDesc'].split('; ')
    end
  end
end
