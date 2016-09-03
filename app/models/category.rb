class Category < ActiveRecord::Base
  has_many :videos, -> { order 'created_at DESC' }

  validates :name, presence: true

  def recent_videos(size = 6)
    videos.first size
  end
end
