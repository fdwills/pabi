require 'pabi/driver/base'
require 'pabi/errors'
require 'pabi/result'

module Pabi
  module Driver
    class Iab < Pabi::Driver::Base
      GOOGLE_PRODUCTION_ENDPOINT = "https://www.googleapis.com/androidpublisher/v1.1/applications/"
      GOOGLE_DEVELOPMENT_ENDPOINT = "https://www.googleapis.com/androidpublisher/v1.1/applications/"

      # The package name of the application the inapp product was sold in (for example, 'com.some.thing').
      attr_reader :package_name
      attr_reader :api_key

      def initialize(env_code, package_name, api_key)
        @package_name = package_name
        @api_key = api_key
        case env_code
        when Pabi::Driver::SANDBOX
          super(:IAB, :SANDBOX, GOOGLE_DEVELOPMENT_ENDPOINT)
        when Pabi::Driver::PRODUCT
          super(:IAB, :PRODUCT, GOOGLE_PRODUCTION_ENDPOINT)
        else
          raise Pabi::Error::NoEnvError.new
        end
      end

      def validate(token, product_id)
        # get response from app store
        json = json_response_date(token, product_id)

        # validate response
        if json['error']
          Pabi::Result.new(-1, Pabi::Error::ValidationError.new(json['error']['code']))
        else
          Pabi::Result.new(0, Pabi::Receipt::IabReceipt.new(json))
        end
      end

      private

      def json_response_date(token, product_id)
        # make client
        # eg https://www.googleapis.com/androidpublisher/v1.1/applications/packageName/inapp/productId/purchases/token
        uri = URI("#{self.url}#{self.package_name}/inapp/#{product_id}/purchases/#{token}?key=#{self.api_key}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # make Get request
        request = Net::HTTP::Get.new(uri.request_uri)
        request['Accept'] = "application/json"
        request['Content-Type'] = "application/json"

        response = http.request(request)

        # get response json
        JSON.parse(response.body)
      end
    end
  end
end
