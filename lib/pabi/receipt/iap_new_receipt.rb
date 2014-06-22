require 'time'

module Pabi
  module Receipt
    # https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW12
    class IapNewReceipt
      # ProductionSandbox etc.
      attr_reader :receipt_type

      # 0 etc.
      attr_reader :adam_id

      # The app’s bundle identifier
      attr_reader :bundle_id

      # The app’s version number.
      attr_reader :application_version

      # 0
      attr_reader :download_id

      # 2014-03-23 17:38:03 Etc\/GMT
      attr_reader :request_date

      # 1395596283823
      attr_reader :request_date_ms

      # 2014-03-23 10:38:03 America\/Los_Angeles
      attr_reader :request_date_pst

      # The receipt for an in-app purchase.
      attr_reader :in_app

      # The date that the app receipt expires.
      attr_reader :expiration_date

      # The version of the app that was originally purchased.
      attr_reader :original_application_version

      def initialize(attributes = {})
        @receipt_type = attributes['receipt_type']
        @adam_id = Integer(attributes['adam_id']) if attributes['adam_id']
        @bundle_id = attributes['bundle_id']
        @application_version = attributes['application_version']
        @download_id = Integer(attributes['download_id']) if attributes['download_id']
        @request_date = DateTime.parse(attributes['request_date']) if attributes['request_date']
        @request_date_ms = attributes['request_date_ms']
        @request_date_pst = attributes['request_date_pst']
        @expiration_date = DateTime.parse(attributes['expiration_date']) if attributes['expiration_date']
        @original_application_version = attributes['original_application_version']
        @in_app = []
        if attributes['in_app']
          attributes['in_app'].each do |r|
            @in_app << IapNewSubReceipt.new(r)
          end
        end
      end
    end

    class IapNewSubReceipt
      # The number of items purchased. This value corresponds to the quantity property of the SKPayment object stored in the transaction’s payment property.
      attr_reader :quantity

      # The product identifier of the item that was purchased. This value corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.
      attr_reader :product_id

      # The transaction identifier of the item that was purchased. This value corresponds to the transaction’s transactionIdentifier property.
      attr_reader :transaction_id

      # The date and time this transaction occurred. This value corresponds to the transaction’s transactionDate property.
      attr_reader :purchase_date

      # purchase date ms
      attr_reader :purchase_date_ms

      # purchase_date_pst : "2014-03-21 12:45:08 America\/Los_Angeles"
      attr_reader :purchase_date_pst

      # For a transaction that restores a previous transaction, this is the original receipt
      attr_accessor :original

      # For an active subscription was renewed with transaction that took place after the receipt your server sent to the App Store, this is the latest receipt.
      attr_accessor :latest

      # For an expired auto-renewable subscription, this contains the receipt details for the latest expired receipt
      attr_accessor :latest_expired

      # For auto-renewable subscriptions, returns the date the subscription will expire
      attr_reader :expires_at

      attr_reader :is_trial_period

      def initialize(attributes = {})
        @quantity = Integer(attributes['quantity']) if attributes['quantity']
        @product_id = attributes['product_id']
        @transaction_id = attributes['transaction_id']
        @purchase_date = DateTime.parse(attributes['purchase_date']) if attributes['purchase_date']
        @is_trial_period = attributes['purchase_date'] == 'true'

        # expires_date is in ms since the Epoch, Time.at expects seconds
        @expires_at = Time.at(attributes['expires_date'].to_i / 1000) if attributes['expires_date']

        if attributes['original_transaction_id'] || attributes['original_purchase_date']
          original_attributes = {
            'transaction_id' => attributes['original_transaction_id'],
            'purchase_date' => attributes['original_purchase_date'],
            'purchase_date_ms' => attributes['original_purchase_date_ms'],
            'purchase_date_pst' => attributes['original_purchase_date_pst'],
          }

          self.original = IapNewSubReceipt.new(original_attributes)
        end
      end
    end
  end
end
