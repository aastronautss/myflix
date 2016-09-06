class QueueMember < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :user, :video, :list_order
end
