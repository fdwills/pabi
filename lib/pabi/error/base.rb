module Pabi::Error
  class Base < StandardError
    attr_reader :code
    def initialize
      @code = -1
    end

    def message
      "Unknown error."
    end
  end
end
