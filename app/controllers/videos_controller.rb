class VideosController < AuthenticatedController
  before_action :require_active_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title params[:q]
  end

  def advanced_search
    if params[:q].present?
      @results = Video.search(params[:q], reviews: (params[:reviews] == 'on')).
        records.to_a.map(&:decorate)
    end
  end
end
