require 'goldfinger/request'
require 'goldfinger/result'
require 'goldfinger/utils'
require 'goldfinger/client'

module Goldfinger
  module Error
    class NotFound < StandardError
    end
  end

  def self.finger(uri)
    Goldfinger::Client.new(uri).finger
  end
end
