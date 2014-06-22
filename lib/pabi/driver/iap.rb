require 'pabi/driver/base'
require 'pabi/errors'
require 'pabi/result'
#require 'base64'

module Pabi
  module Driver
    class Iap < Pabi::Driver::Base
      ITUNES_PRODUCTION_ENDPOINT = "https://buy.itunes.apple.com/verifyReceipt"
      ITUNES_DEVELOPMENT_ENDPOINT = "https://sandbox.itunes.apple.com/verifyReceipt"

      def initialize(env_code)
        case env_code
        when Pabi::Driver::SANDBOX
          super(:IAP, :SANDBOX, ITUNES_DEVELOPMENT_ENDPOINT)
        when Pabi::Driver::PRODUCT
          super(:IAP, :PRODUCT, ITUNES_PRODUCTION_ENDPOINT)
        else
          raise Pabi::Error::NoEnvError.new
        end
      end

      def validate(raw_receipt, option = nil)
        # get response from app store
        json = json_response_date(raw_receipt)
        status, receipt_attributes = json['status'].to_i, json['receipt']
        # validate response

        # 0: success
        # 21006: success, but subscription is expired
        case status
        when 0, 21006
          Pabi::Result.new(0, Pabi::Receipt::IapReceiptFactory.make(receipt_attributes))
        else
          Pabi::Result.new(-1, Pabi::Error::ValidationError.new(json['status']))
        end
      end

      private

      def json_response_date(data)
        parameters = {
          'receipt-data' => data
        }

        #parameters['password'] = @shared_secret if @shared_secret

        # make client
        uri = URI(self.url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # make post request
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Accept'] = "application/json"
        request['Content-Type'] = "application/json"
        request.body = parameters.to_json

        response = http.request(request)

        # get response json
        JSON.parse(response.body)
      end
    end
  end
end
