class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  # validates_presence_of :video
  validates_presence_of :user, :rating, :body

  validates_numericality_of :rating,
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1

  delegate :title, to: :video, prefix: 'video'
  # validates_uniqueness_of :user_id, scope: :video_id
end
