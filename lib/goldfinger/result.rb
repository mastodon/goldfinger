module Goldfinger
  class Result
    def initialize(headers, body)
      @mime_type  = headers.get(HTTP::Headers::CONTENT_TYPE).first
      @body       = body
      @subject    = nil
      @aliases    = []
      @links      = {}
      @properties = {}

      parse
    end

    # The value of the "subject" member is a URI that identifies the entity
    # that the JRD describes.
    # @return [String]
    def subject
      @subject
    end

    # The "aliases" array is an array of zero or more URI strings that
    # identify the same entity as the "subject" URI.
    # @return [Array]
    def aliases
      @aliases
    end

    # The "properties" object comprises zero or more name/value pairs whose
    # names are URIs (referred to as "property identifiers") and whose
    # values are strings or nil.
    # @see #property
    # @return [Array] Array form of the hash
    def properties
      @properties.to_a
    end

    # Returns a property for a key
    # @param key [String]
    # @return [String]
    def property(key)
      @properties[key]
    end

    # The "links" array has any number of member objects, each of which
    # represents a link.
    # @see #link
    # @return [Array] Array form of the hash
    def links
      @links.to_a
    end

    # Returns a key for a relation
    # @param key [String]
    # @return [Goldfinger::Link]
    def link(rel)
      @links[rel]
    end

    private

    def parse
      case @mime_type
      when 'application/jrd+json', 'application/json'
        parse_json
      when 'application/xrd+xml'
        parse_xml
      end
    end

    def parse_json
      json = JSON.parse(@body)

      @subject    = json['subject']
      @aliases    = json['aliases'] || []
      @properties = json['properties'] || {}

      json['links'].each do |link|
        tmp = Hash[link.keys.map { |key| [key.to_sym, link[key]] }]
        @links[link['rel']] = Goldfinger::Link.new(tmp)
      end
    end

    def parse_xml
      xml = Nokogiri::XML(@body)

      @subject = xml.at_xpath('//xmlns:Subject').content
      @aliases = xml.xpath('//xmlns:Alias').map { |a| a.content }

      properties = xml.xpath('/xmlns:XRD/xmlns:Property')
      properties.each { |prop| @properties[prop.attribute('type').value] = prop.attribute('nil') ? nil : prop.content }

      xml.xpath('//xmlns:Link').each do |link|
        rel = link.attribute('rel').value
        tmp = Hash[link.attributes.keys.map { |key| [key.to_sym, link.attribute(key).value] }]

        tmp[:titles] = {}
        tmp[:properties] = {}

        link.xpath('.//xmlns:Title').each { |title| tmp[:titles][title.attribute('lang').value] = title.content }
        link.xpath('.//xmlns:Property').each { |prop| tmp[:properties][prop.attribute('type').value] = prop.attribute('nil') ? nil : prop.content }

        @links[rel] = Goldfinger::Link.new(tmp)
      end
    end
  end
end
