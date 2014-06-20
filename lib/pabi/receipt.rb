require 'time'

module Pabi

  class Receipt
    # The number of items purchased. This value corresponds to the quantity property of the SKPayment object stored in the transaction’s payment property.
    attr_reader :quantity

    # The product identifier of the item that was purchased. This value corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.
    attr_reader :product_id

    # The transaction identifier of the item that was purchased. This value corresponds to the transaction’s transactionIdentifier property.
    attr_reader :transaction_id

    # The date and time this transaction occurred. This value corresponds to the transaction’s transactionDate property.
    attr_reader :purchase_date

    # A string that the App Store uses to uniquely identify the application that created the payment transaction. If your server supports multiple applications, you can use this value to differentiate between them. Applications that are executing in the sandbox do not yet have an app-item-id assigned to them, so this key is missing from receipts created by the sandbox.
    attr_reader :app_item_id

    # An arbitrary number that uniquely identifies a revision of your application. This key is missing in receipts created by the sandbox.
    attr_reader :version_external_identifier

    # The bundle identifier for the application.
    attr_reader :bid

    # A version number for the application.
    attr_reader :bvrs

    # For a transaction that restores a previous transaction, this is the original receipt
    attr_accessor :original

    # For an active subscription was renewed with transaction that took place after the receipt your server sent to the App Store, this is the latest receipt.
    attr_accessor :latest

    # For an expired auto-renewable subscription, this contains the receipt details for the latest expired receipt
    attr_accessor :latest_expired

    # For auto-renewable subscriptions, returns the date the subscription will expire
    attr_reader :expires_at

    def initialize(attributes = {})
      @quantity = Integer(attributes['quantity']) if attributes['quantity']
      @product_id = attributes['product_id']
      @transaction_id = attributes['transaction_id']
      @purchase_date = DateTime.parse(attributes['purchase_date']) if attributes['purchase_date']
      @app_item_id = attributes['app_item_id']
      @version_external_identifier = attributes['version_external_identifier']
      @bid = attributes['bid']
      @bvrs = attributes['bvrs']

      # expires_date is in ms since the Epoch, Time.at expects seconds
      @expires_at = Time.at(attributes['expires_date'].to_i / 1000) if attributes['expires_date']

      if attributes['original_transaction_id'] || attributes['original_purchase_date']
        original_attributes = {
          'transaction_id' => attributes['original_transaction_id'],
          'purchase_date' => attributes['original_purchase_date']
        }

        self.original = Receipt.new(original_attributes)
      end
    end

    def to_json
      {
        :quantity => @quantity,
        :product_id => @product_id,
        :transaction_id => @transaction_id,
        :purchase_date => (@purchase_date.httpdate rescue nil),
        :original_transaction_id => (@original.transaction_id rescue nil),
        :original_purchase_date => (@original.purchase_date.httpdate rescue nil),
        :app_item_id => @app_item_id,
        :version_external_identifier => @version_external_identifier,
        :bid => @bid,
        :bvrs => @bvrs,
        :expires_at => (@expires_at.httpdate rescue nil)
      }.to_json
    end
  end
end
