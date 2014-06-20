require 'pabi/driver/base'

module Pabi::Driver
  class Iab << Pabi::Driver::Base
    def validate(date, option)
      p "Iab"
    end
  end
end
