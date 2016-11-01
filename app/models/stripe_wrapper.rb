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
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
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
