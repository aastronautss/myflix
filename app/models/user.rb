class User < ActiveRecord::Base
  has_many :reviews, -> { order 'created_at desc' }, dependent: :destroy
  has_many :queue_members, -> { order('list_order asc') }, dependent: :destroy

  has_many :active_followings, class_name: 'Following',
    foreign_key: 'follower_id',
    dependent: :destroy
  has_many :passive_followings, class_name: 'Following',
    foreign_key: 'followed_id',
    dependent: :destroy
  has_many :followed_users, through: :active_followings, source: :followed
  has_many :followers, through: :passive_followings, source: :follower

  has_secure_password validations: false

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password, length: { minimum: 5, maximum: 30 }
  validates :full_name, length: { minimum: 2 }

  # ====-----------------------====
  # Queue Stuff
  # ====-----------------------====

  def add_to_queue(video)
    member = self.queue_members.build video: video,
                                      list_order: self.next_queue_order

    member.save ? member : false
  end

  def has_video_in_queue?(video)
    self.queue_members.map(&:video).include? video
  end

  def next_queue_order
    (self.queue_members.maximum(:list_order) || 0) + 1
  end

  def normalize_queue_member_orders
    queue_members.each_with_index do |member, index|
      member.update! list_order: index + 1
    end
  end

  # ====-----------------------====
  # Following Stuff
  # ====-----------------------====

  def follow(other_user)
    following = Following.new follower: self, followed: other_user

    begin
      following.save
    rescue ActiveRecord::RecordNotUnique
      return false
    end

    following
  end

  def unfollow(other_user)
    active_followings.find_by(followed_id: other_user.id).destroy
  end

  def is_following?(other_user)
    followed_users.include? other_user
  end
end
