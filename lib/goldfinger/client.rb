require 'addressable'
require 'nokogiri'

module Goldfinger
  class Client
    include Goldfinger::Utils

    def initialize(uri)
      @uri = uri
    end

    def finger
      ssl = true

      begin
        response = perform_get(standard_url(ssl))

        return finger_from_template if response.code != 200

        Goldfinger::Result.new(response)
      rescue HTTP::Error, OpenSSL::SSL::SSLError
        raise Goldfinger::NotFoundError unless ssl

        ssl = false
        retry
      end
    rescue HTTP::Error
      raise Goldfinger::NotFoundError
    rescue OpenSSL::SSL::SSLError
      raise Goldfinger::SSLError
    rescue Addressable::URI::InvalidURIError
      raise Goldfinger::NotFoundError, 'Invalid URI'
    end

    private

    def finger_from_template
      ssl = true

      begin
        template = perform_get(url(ssl))
      rescue HTTP::Error, OpenSSL::SSL::SSLError
        raise Goldfinger::NotFoundError unless ssl

        ssl = false
        retry
      end

      raise Goldfinger::NotFoundError, 'No host-meta on the server' if template.code != 200

      response = perform_get(url_from_template(template.body))

      raise Goldfinger::NotFoundError, 'No such user on the server' if response.code != 200

      Goldfinger::Result.new(response)
    end

    def url(ssl = true)
      "http#{'s' if ssl}://#{domain}/.well-known/host-meta"
    end

    def standard_url(ssl = true)
      "http#{'s' if ssl}://#{domain}/.well-known/webfinger?resource=#{@uri}"
    end

    def url_from_template(template)
      xml   = Nokogiri::XML(template)
      links = xml.xpath('//xmlns:Link[@rel="lrdd"]')

      raise Goldfinger::NotFoundError if links.empty?

      links.first.attribute('template').value.gsub('{uri}', @uri)
    rescue Nokogiri::XML::XPath::SyntaxError
      raise Goldfinger::Error, "Bad XML: #{template}"
    end

    def domain
      @uri.split('@').last
    end
  end
end
