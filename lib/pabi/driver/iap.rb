require 'pabi/driver/base'

module Pabi::Driver
  class Iap < Pabi::Driver::Base
    ITUNES_PRODUCTION_RECEIPT_VERIFICATION_ENDPOINT = "https://buy.itunes.apple.com/verifyReceipt"
    ITUNES_DEVELOPMENT_RECEIPT_VERIFICATION_ENDPOINT = "https://sandbox.itunes.apple.com/verifyReceipt"

    def initialize(env_code)
      case env_code
      when Pabi::Driver::SANDBOX
        super(:IAP, :SANDBOX, ITUNES_DEVELOPMENT_RECEIPT_VERIFICATION_ENDPOINT)
      when Pabi::Driver::PRODUCT
        super(:IAP, :PRODUCT, ITUNES_PRODUCTION_RECEIPT_VERIFICATION_ENDPOINT)
      else
        raise Pabi::Error::NoEnvError.new
      end
    end

    def validate(date, option)
      # get raw receipt from data
      receipt = get_receipt(data)

      # get response from app store
      response_json = json_response_date(receipt)

      # validate response
      if check_response_data(response_json)
        Pabi::Result.new(0, Pabi::Receipt::IapReceiptFactory.new(response_json))
      else
        Pabi::Result.new(-1, Pabi::Error::ValidationError.new(response_json['status']))
      end
    end

    private

    def get_receipt(data)
      data
    end

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

    def check_response_data(response_json, option)
      true
    end
  end
end
