class PaymentDecorator < Draper::Decorator
  delegate_all

  def amount_to_currency
    h.number_to_currency(model.amount.to_f / 100)
  end
end
