module Pabi
  module Receipt
    class IapReceiptFactory
      def self.make(response_json)
        if response_json.nil?
          nil
        elsif is_new?(response_json)
          Pabi::Receipt::IapNewReceipt.new(response_json)
        else
          Pabi::Receipt::IapOldReceipt.new(response_json)
        end
      end

      private

      def self.is_new?(response_json)
        return false if response_json["receipt"].nil?

        receipt = response_json["receipt"]
        return false if response_json["in_app"].nil?

        true
      end
    end
  end
end
