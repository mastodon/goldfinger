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
      json['links'].each { |link| @links[link['rel']] = link['href'] }
    end

    def parse_xml
      xml = Nokogiri::XML(@body)
      xml.xpath('//xmlns:Link', xmlns: 'http://docs.oasis-open.org/ns/xri/xrd-1.0').each { |link| @links[link.attribute('rel').value] = link.attribute('href').value }
    end
  end
end
