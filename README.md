Pabi
===================

## Description

Ruby gem for Iap(apple In-App Pruchase) and Iab(google In-App Billing) server validation

## Latest Version

v0.0.1

## Install

    gem install pabi

or include in Gemfile

    gem 'pabi'

## Usage

### Iap

Iap server-side receipt validation need a receipt

#### Sample Code

```ruby
require "pabi"

# initial a new client for validation(SANDBOX / PRODUCT)
client = Pabi::client.new(:IAP, Pabi::Driver::SANDBOX)

# validate a receipt string
result = client.validate("receipt_string")

if result.succeed?
  receipt = result.receipt
  # do something with receipt
else
  error = result.error
  # do something with error
end
```

#### Receipt before iOS7.0

| method | type | description |
|--------|------|-------------|
| quantity | number | The number of items purchased. This value corresponds to the quantity property of the SKPayment object stored in the transaction’s payment property.|
| product_id | string | The product identifier of the item that was purchased. This value corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.|
| transaction_id | string | The transaction identifier of the item that was purchased. This value corresponds to the transaction’s transactionII dentifier property.|
| purchase_date | DateTime | The date and time this transaction occurred. This value corresponds to the transaction’s transactionDate property. |
| app_item_it | string | A string that the App Store uses to uniquely identify the application that created the payment transaction. If your server supports multiple applications, you can use this value to differentiate between them. Applications that are executing in the sandbox do not yet have an app-item-id assigned to them, so this key is missing from receipts created by the sandbox. |
| version_external_identifier | string | An arbitrary number that uniquely identifies a revision of your application. This key is missing in receipts created by the sandbox.|
| bid | string | The bundle identifier for the application. |
| bvrs | string |  A version number for the application.|
| original | Object | For a transaction that restores a previous transaction, this is the original receipt |
| expires_at | DateTime | For auto-renewable subscriptions, returns the date the subscription will expire |

#### Receipt after iOS7.0

see [here](https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW12)

| method | type |description |
|--------|------|------------|
| bundle_id | string | The app's bundle identifier.|
| application_version| string | The app's version number.(In the sandbox environment, the value of this field is always "1.0".)|
| original_application_version | string | The version of the app that was originally purchased.|
| expiration_date | DateTime | The date that the app receipt expires.
| in_app | array(SubReceipt) | The receipt for an in-app purchase. (see below)|

In-app purchase object

| method | type | description |
|--------|------|-------------|
| product_id | string | The product identifier of the item that was purchased. |
| quantity | number | The number of items purchased.|
| transaction_id | string | The transaction identifier of the item that was purchased. |
| original_transaction_id | string | For a transaction that restores a previous transaction, the transaction identifier of the original transaction. Otherwise, identical to the transaction identifier. |
| purchase_date | DateTime | The date and time that the item was purchased. |
| original_purchase_date | DateTime | For a transaction that restores a previous transaction, the date of the original transaction. |
| expires_date | DateTime | The expiration date for the subscription, expressed as the number of milliseconds since January 1, 1970, 00:00:00 GMT. |
| cancellation_date | DateTime |For a transaction that was canceled by Apple customer support, the time and date of the cancellation. |
| app_item_id | string | A string that the App Store uses to uniquely identify the application that created the transaction. |
| version_external_identifier | string | An arbitrary number that uniquely identifies a revision of your application. (This key is not present for receipts created in the test environment.)
| web_order_line_item_id | string | The primary key for identifying subscription purchases.|

### Iab

Iab server receipt validation needs a receipt data, android package name and a token.

Only purchase made by __In-app Billing v3__ can be retrivaled.

see [here](https://developers.google.com/android-publisher/v1_1/inapppurchases) and also [here](https://developer.android.com/google/play/billing/gp-purchase-status-api.html)

#### Sample Code

```ruby
require "pabi"

# initial a new client for validation(SANDBOX / PRODUCT)
# initial client also need a android package name
# initial client also need api key
client = Pabi::client.new(:IAB, Pabi::Driver::SANDBOX, "package_name", "api_key")

# validate a receipt string
# validate a receipt also nedd a product id
result = client.validate("receipt_string", "product_id")

if result.succeed?
  receipt = result.receipt
  # do something with receipt
else
  error = result.error
  # do something with error
```

#### Iab Receipt

| method | type | description |
|--------|------|-------------|
| consumptionState | integer |The consumption state of the inapp product. Possible values are - 0: Yet to be consumed, 1: Consumed |
| developerPayload | string | A developer-specified string that contains supplemental information about an order. |
| kind | string | This kind represents an inappPurchase object in the androidpublisher service. |
| purchaseState | number | The purchase state of the order. Possible values are - 0: Purchased, 1: Cancelled |
| purchaseTime | number | The time the product was purchased, in milliseconds since the epoch (Jan 1, 1970). |
