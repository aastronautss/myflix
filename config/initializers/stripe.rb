Stripe.api_key = ENV['STRIPE_API_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by stripe_customer_id: event.data.object.customer
    amount = event.data.object.amount
    reference_id = event.data.object.id

    Payment.create user: user, amount: amount, reference_id: reference_id
  end
end
