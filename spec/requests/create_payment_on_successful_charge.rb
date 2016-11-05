require 'spec_helper'

describe 'create payment on successful charge', :vcr do
  let(:event_data) do
    {
      "id" => "evt_19Ccu9FgeUvs3GmudtkaLLuU",
      "object" => "event",
      "api_version" => "2016-07-06",
      "created" => 1478385893,
      "data" => {
        "object" => {
          "id" => "ch_19Ccu9FgeUvs3GmuN5SRAvSn",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_19Ccu9FgeUvs3Gmuau2iiuOQ",
          "captured" => true,
          "created" => 1478385893,
          "currency" => "usd",
          "customer" => "cus_9VeC7SVZmZNl4Z",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_19Ccu9FgeUvs3GmuXFgoDnUy",
          "livemode" => false,
          "metadata" => {
          },
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [

            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_19Ccu9FgeUvs3GmuN5SRAvSn/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_19Ccu8FgeUvs3GmuWFNxnC6F",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_9VeC7SVZmZNl4Z",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2021,
            "fingerprint" => "BKTw6Ixt61DE2nPW",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "myflix basic",
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_9VeC70ssUNo6FV",
      "type" => "charge.succeeded"
    }
  end

  let!(:user) { Fabricate :user, stripe_customer_id: 'cus_9VeC7SVZmZNl4Z' }
  let(:action) { post '/stripe_events', event_data }

  it 'creates a payment with the webhook from stripe' do
    expect{ action }.to change(Payment, :count).by(1)
  end

  it 'creates the payment associated with the user' do
    action
    expect(Payment.first.user).to eq(user)
  end

  it 'creates the payment with the amount' do
    action
    expect(Payment.first.amount).to eq(999)
  end

  it 'creates the payment with reference id' do
    action
    expect(Payment.first.reference_id).to eq('ch_19Ccu9FgeUvs3GmuN5SRAvSn')
  end
end
