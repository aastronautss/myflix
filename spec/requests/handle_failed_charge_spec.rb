require 'spec_helper'

describe 'handle failed charge', :vcr do
  let(:event_data) do
    {
      "id" => "evt_19DE6aFgeUvs3GmuYNCa2Xc9",
      "object" => "event",
      "api_version" => "2016-07-06",
      "created" => 1478528892,
      "data" => {
        "object" => {
          "id" => "ch_19DE6ZFgeUvs3GmuacG9iNuY",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1478528891,
          "currency" => "usd",
          "customer" => "cus_9VfHcmilKdOigo",
          "description" => "failure",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_19DE6ZFgeUvs3GmuacG9iNuY/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_19DE41FgeUvs3Gmuwvy8nE7Z",
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
            "customer" => "cus_9VfHcmilKdOigo",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2025,
            "fingerprint" => "JdFb5cdIk9LqsEmo",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "myflix basic",
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_9WGdgG9ok6zXh1",
      "type" => "charge.failed"
    }
  end

  let!(:user) { Fabricate :user, stripe_customer_id: 'cus_9VfHcmilKdOigo' }
  let(:action) { post '/stripe_events', event_data }

  after { ActionMailer::Base.deliveries.clear }

  it 'does not create a payment' do
    expect{ action }.to change(Payment, :count).by(0)
  end

  it 'locks the associated user\'s account' do
    action
    expect(user.reload).to_not be_active
  end

  it 'sends a notification email to the user' do
    action
    deliveries = ActionMailer::Base.deliveries
    expect(deliveries).to_not be_empty
    expect(deliveries.last.to).to include(user.email)
  end
end
