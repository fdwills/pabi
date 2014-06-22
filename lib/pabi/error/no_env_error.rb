require 'pabi/error/base'

module Pabi
  module Error
    class NoDriverError < Pabi::Error::Base
      def initialize
        @code = -3
      end

      def message
        "No such enviroment."
      end
    end
  end
end
