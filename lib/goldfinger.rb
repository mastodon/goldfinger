require 'goldfinger/request'
require 'goldfinger/result'
require 'goldfinger/utils'
require 'goldfinger/client'

module Goldfinger
  class Error < StandardError
  end

  class NotFoundError < Error
  end

  class SSLError < Error
  end

  def self.finger(uri)
    Goldfinger::Client.new(uri).finger
  end
end
