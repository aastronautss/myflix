class QueueMember < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  # validates_presence_of :user, :video, :list_order

  validates_uniqueness_of :video_id, scope: :user_id

  validates_numericality_of :list_order, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review = Review.find_by(user: self.user, video: self.video)
    review.nil? ? nil : review.rating
  end
end
