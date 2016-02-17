module Goldfinger
  class Result
    def initialize(headers, body)
      @mime_type = headers.get(HTTP::Headers::CONTENT_TYPE).first
      @body      = body
      @links     = {}

      parse
    end

    def links
      @links.to_a
    end

    def link(rel)
      @links[rel]
    end

    private

    def parse
      case @mime_type
      when 'application/jrd+json'
        parse_json
      when 'application/xrd+xml'
        parse_xml
      end
    end

    def parse_json
      json = JSON.parse(@body)
      json['links'].each { |link| @links[link['rel']] = Hash[link.keys.map { |key| [key.to_sym, link[key]] }] }
    end

    def parse_xml
      xml = Nokogiri::XML(@body)
      links = xml.xpath('//xmlns:Link', xmlns: 'http://docs.oasis-open.org/ns/xri/xrd-1.0')
      links.each { |link| @links[link.attribute('rel').value] = Hash[link.attributes.keys.map { |key| [key.to_sym, link.attribute(key).value] }] }
    end
  end
end
