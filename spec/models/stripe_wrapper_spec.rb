require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card' do
        it 'charges the card successfully', :vcr do
          Stripe.api_key = ENV['STRIPE_API_KEY']

          token = Stripe::Token.create(
            card: {
              number: '4242424242424242',
              exp_month: 6,
              exp_year: 1.years.from_now.year,
              cvc: 123
            }
          ).id

          response = StripeWrapper::Charge.create(
            amount: 999,
            card: token,
            description: 'a valid charge'
          )

          expect(response.amount).to eq(999)
        end
      end

      context 'with invalid card'
    end

  end
end

