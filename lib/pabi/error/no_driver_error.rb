require 'pabi/error/base'

module Pabi
  module Error
    class NoDriverError < Pabi::Error::Base
      def initialize
        @code = -2
      end
      def message
        "No such driver."
      end
    end
  end
end
