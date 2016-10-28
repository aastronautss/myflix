module StripeWrapper
  class Charge
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options = {})
      StripeWrapper.set_api_key

      response = Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        card: options[:card]
      )

      new(response, :success)
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end
end
