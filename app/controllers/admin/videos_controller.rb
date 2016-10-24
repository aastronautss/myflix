class Admin::VideosController < AdminController
  def new
    @video = Video.new
    @categories = Category.all
  end

  def create
    @video = Video.new video_params
    @categories = Category.all

    if @video.save
      flash[:success] = 'Video added!'
      redirect_to @video
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit :title, :small_cover_url, :large_cover_url, :description, :category_id
  end
end
