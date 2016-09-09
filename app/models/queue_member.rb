class QueueMember < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  # validates_presence_of :user, :video, :list_order

  validates_uniqueness_of :video_id, scope: :user_id

  def video_title
    self.video.title
  end
end
