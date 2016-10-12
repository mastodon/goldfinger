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
        template = perform_get(url(ssl))
      rescue HTTP::Error
        if ssl
          ssl = false
          retry
        else
          raise Goldfinger::NotFoundError
        end
      end

      raise Goldfinger::NotFoundError, "No host-meta on the server" if template.code != 200

      response = perform_get(url_from_template(template.body))

      raise Goldfinger::NotFoundError, "No such user on the server" if response.code != 200

      Goldfinger::Result.new(response)
    rescue HTTP::Error
      raise Goldfinger::NotFoundError
    rescue OpenSSL::SSL::SSLError
      raise Goldfinger::SSLError
    end

    private

    def url(ssl = true)
      "http#{'s' if ssl}://#{domain}/.well-known/host-meta"
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
