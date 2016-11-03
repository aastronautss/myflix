require 'spec_helper'

describe StripeWrapper, :vcr do
  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card' do
        it 'charges the card successfully' do
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
            card: token,
            email: 'a@b.c'
          )

          expect(response).to be_successful
        end
      end

      context 'with invalid card' do
        before { Stripe.api_key = ENV['STRIPE_API_KEY'] }

        let(:token) do
          Stripe::Token.create(
            card: {
              number: '4000000000000002',
              exp_month: 6,
              exp_year: 1.years.from_now.year,
              cvc: 123
            }
          ).id
        end

        let(:response) do
          StripeWrapper::Charge.create(
            card: token,
            email: 'a@b.c'
          )
        end

        it 'does not charge the card' do
          expect(response).to_not be_successful
        end

        it 'returns an error message' do
          expect(response.message).to be_present
        end
      end
    end

  end
end

