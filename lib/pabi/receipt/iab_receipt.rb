require 'time'

module Pabi
  module Receipt
    class IabReceipt
      # ref https://developers.google.com/android-publisher/v1_1/inapppurchases#resource
      attr_reader :consumptionState
      attr_reader :developerPayload
      attr_reader :kind
      attr_reader :purchaseState
      attr_reader :purchaseTime

      def initialize(attributes = {})
        @consumptionState = Integer(attributes['consumptionState']) if attributes['consumptionState']
        @developerPayload = attributes['developerPayload']
        @kind = attributes['kind']
        @purchaseState = Integer(attributes['purchaseState']) if attributes['purchaseState']
        @purchaseTime = DateTime.strptime(attributes['purchaseTime'].to_s, '%s') if attributes['purchaseTime']
      end
    end
  end
end
