module Pabi
  class Result
    SUCCEED = 0
    FAILED = -1
    attr_reader :state

    def initialize(state, data)
      @state = Integer state
      case @state
      when SUCCEED
        @receipt = data
      else
        @error = data
      end
    end

    def succeed?
      self.state == SUCCEED
    end

    def failed?
      !succeed?
    end

    def error
      failed? ? @error : nil
    end

    def receipt
      succeed? ? @receipt : nil
    end
  end
end
