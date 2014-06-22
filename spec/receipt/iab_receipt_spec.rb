require 'spec_helper'

describe Pabi::Receipt::IabReceipt do
  describe "parsing the response" do
    let(:response) {
      {
        "kind" => "androidpublisher.inappPurchase",
        "purchaseTime" => 1395596283823,
        "purchaseState" => 0,
        "consumptionState" => 0,
        "developerPayload" => "efssdf913nr42131r21e1"
      }
    }
    subject { Pabi::Receipt::IabReceipt.new(response) }

    its(:consumptionState) { 0 }
    its(:developerPayload) { "efssdf913nr42131r21e1" }
    its(:kind) { "androidpublisher.inappPurchase" }
    its(:purchaseState) { 0 }
    its(:purchaseTime) { should be_instance_of DateTime }
  end
end
