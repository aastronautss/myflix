module StripeWrapper
  class Charge
    attr_reader :message

    def initialize(options = {})
      @response = options[:response]
      @message = options[:message]
    end

    def self.create(options = {})
      StripeWrapper.set_api_key

      begin
        response = Stripe::Customer.create(
          source: options[:card],
          plan: 'myflix_basic',
          email: options[:email]
        )

        new(response: response)
      rescue Stripe::CardError => e
        new(message: e.message)
      end
    end

    def successful?
      @response.present?
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end
end
