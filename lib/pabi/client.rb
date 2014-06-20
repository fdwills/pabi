require 'pabi/errors'

module Pabi
  class Client
    def initialize(type, mode)
      case type
      when :IAP
        # new iap driver
        @driver = Driver::Iap.new(mode)
      when :IAB
        # new iab driver
        @driver = Driver::Iab.new(mode)
      else
        raise Pabi::Error::NoDriverError.new
      end
    end

    def validate(date, option)
      self.driver.validate(date, option)
    end
  end
end
