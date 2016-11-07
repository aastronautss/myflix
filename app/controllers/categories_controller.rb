class CategoriesController < AuthenticatedController
  before_action :require_active_user

  def show
    @category = Category.find params[:id]
  end
end
