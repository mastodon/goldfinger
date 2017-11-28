# frozen_string_literal: true

require 'goldfinger/request'
require 'goldfinger/link'
require 'goldfinger/result'
require 'goldfinger/utils'
require 'goldfinger/client'

module Goldfinger
  class Error < StandardError
  end

  class NotFoundError < Error
  end

  # Returns result for the Webfinger query
  #
  # @raise [Goldfinger::NotFoundError] Error raised when the Webfinger resource could not be retrieved
  # @raise [Goldfinger::SSLError] Error raised when there was a SSL error when fetching the resource
  # @param uri [String] A full resource identifier in the format acct:user@example.com
  # @param opts [Hash] Options passed to HTTP.rb client
  # @param ssl [Boolean] Whether performs secure HTTP reqest. MUST NOT set to false in the usual case
  # @return [Goldfinger::Result]
  def self.finger(uri, opts = {}, ssl = true)
    Goldfinger::Client.new(uri, opts, ssl).finger
  end
end
