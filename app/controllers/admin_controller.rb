class AdminController < AuthenticatedController
  before_action :require_admin

  def require_admin
    access_denied('You do not have access to that area') unless current_user.admin?
  end
end
