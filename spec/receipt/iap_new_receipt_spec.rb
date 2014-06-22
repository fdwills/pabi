require 'spec_helper'

describe Pabi::Receipt::IapOldReceipt do
  describe "parsing the response" do
    let(:response) {
        {
           "status" => 0,
           "environment" => "Sandbox",
           "receipt" => {
              "receipt_type" => "ProductionSandbox",
              "adam_id" => 0,
              "bundle_id" => "<<snip>>",
              "application_version" => "0.6",
              "download_id" => 0,
              "request_date" => "2014-03-23 17:38:03 Etc/GMT",
              "request_date_ms" => "1395596283823",
              "request_date_pst" => "2014-03-23 10:38:03 America/Los_Angeles",
              "in_app" => [
                 {
                    "quantity" => "1",
                    "product_id" => "Gems500",
                    "transaction_id" => "1000000105271988",
                    "original_transaction_id" => "1000000105271988",
                    "purchase_date" => "2014-03-21 19:45:08 Etc/GMT",
                    "purchase_date_ms" => "1395431108000",
                    "purchase_date_pst" => "2014-03-21 12:45:08 America/Los_Angeles",
                    "original_purchase_date" => "2014-03-21 15:13:47 Etc/GMT",
                    "original_purchase_date_ms" => "1395414827000",
                    "original_purchase_date_pst" => "2014-03-21 08:13:47 America/Los_Angeles",
                    "is_trial_period" => "false"
                 },
                 {
                    "quantity" => "1",
                    "product_id" => "Gems500",
                    "transaction_id" => "1000000105295974",
                    "original_transaction_id" => "1000000105295974",
                    "purchase_date" => "2014-03-21 19:45:08 Etc/GMT",
                    "purchase_date_ms" => "1395431108000",
                    "purchase_date_pst" => "2014-03-21 12:45:08 America/Los_Angeles",
                    "original_purchase_date" => "2014-03-21 19:45:08 Etc/GMT",
                    "original_purchase_date_ms" => "1395431108000",
                    "original_purchase_date_pst" => "2014-03-21 12:45:08 America/Los_Angeles",
                    "is_trial_period" => "false"
                 }
              ]
           }
        }
      }

    subject { Pabi::Receipt::IapNewReceipt.new(response['receipt']) }

    its(:receipt_type) { "ProductionSandbox" }
    its(:adam_id) { 0 }
    its(:bundle_id) { "<<snip>>" }
    its(:application_version) { "0.6" }
    its(:download_id) { 0 }
    its(:request_date) { should be_instance_of DateTime }
    its(:request_date_pst) { "2014-03-23 10:38:03 America\/Los_Angeles" }

    it "should parse the origin attributes" do
      expect(subject.in_app.length).to be(2)
    end
  end
end
