class Admin::PaymentsController < AdminController
  def index
    @payments = Payment.order('created_at desc').limit(10).decorate
  end
end
