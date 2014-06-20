module Pabi::Receipt
  class IapReceiptFactory
    def make(response_json) << self
      if response_json.nil?
        nil
      elsif is_new?(response_json)
        Pabi::Receipt::IapNewReceipt.new(response_json)
      else
        Pabi::Receipt::IapOldReceipt.new(response_json)
      end
    end
  end

  private

  def is_new?(response_json)
    return false if response_json["receipt"].nil?

    receipt = response_json["receipt"]
    return false if response_json["in_app"].nil?

    true
  end
end
