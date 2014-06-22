require 'pabi/errors'

module Pabi
  class Client
    attr_reader :driver

    def initialize(type, mode, *args)
      case type
      when :IAP
        # new iap driver
        @driver = Driver::Iap.new(mode)
      when :IAB
        # new iab driver
        @driver = Driver::Iab.new(mode, args[0], args[1])
      else
        raise Pabi::Error::NoDriverError.new
      end
    end

    def validate(date, option = nil)
      self.driver.validate(date, option)
    end
  end
end
