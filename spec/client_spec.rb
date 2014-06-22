require 'spec_helper'

describe Pabi::Client do
  let(:receipt_data) { "asdfzxcvjklqwer" }
  let(:client) { subject }

  describe "#iap" do
    context "with iap old receipt" do
      let(:raw_receipt) { receipt_from("sample/iap_old_receipt") }
      let(:iap_sandbox_client) { Pabi::Client.new(:IAP, 0) }

      it "should new and validate success" do
        expect(iap_sandbox_client.driver).to be_an_instance_of(Pabi::Driver::Iap)

        result = iap_sandbox_client.validate(raw_receipt)
        expect(result).to be_an_instance_of(Pabi::Result)
        expect(result.succeed?).to be_true
        expect(result.receipt).to be_an_instance_of(Pabi::Receipt::IapOldReceipt)
      end
    end

    context "with iap new receipt error receipt 1" do
      let(:raw_receipt) { receipt_from("sample/iap_new_receipt_error_21002") }
      let(:iap_sandbox_client) { Pabi::Client.new(:IAP, 0) }

      it "should new and validate success" do
        expect(iap_sandbox_client.driver).to be_an_instance_of(Pabi::Driver::Iap)

        result = iap_sandbox_client.validate(raw_receipt)
        expect(result).to be_an_instance_of(Pabi::Result)

        expect(result.succeed?).to be_false
        expect(result.error).to be_an_instance_of(Pabi::Error::ValidationError)
        expect(result.error.code).to be(21002)
      end
    end
  end

  describe "#iab" do
    context "with iab invalid receipt" do
      let(:raw_receipt) { "asaadfdafssaaad" }
      let(:iab_sandbox_client) { Pabi::Client.new(:IAB, 0, 'aaa', 'sss') }

      it "should new and validate success" do
        expect(iab_sandbox_client.driver).to be_an_instance_of(Pabi::Driver::Iab)

        result = iab_sandbox_client.validate(raw_receipt,"product_id")
        expect(result).to be_an_instance_of(Pabi::Result)
        expect(result.succeed?).to be_false
        expect(result.error).to be_an_instance_of(Pabi::Error::ValidationError)
        expect(result.error.code).to be(401)
      end
    end
  end
end
