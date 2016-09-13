class User < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :queue_members, -> { order('list_order asc') }, dependent: :destroy

  has_secure_password validations: false

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password, length: { minimum: 5, maximum: 30 }
  validates :full_name, length: { minimum: 2 }

  def add_to_queue(video)
    member = self.queue_members.build video: video,
                                      list_order: self.next_queue_order

    member.save ? member : false
  end

  def next_queue_order
    (self.queue_members.maximum(:list_order) || 0) + 1
  end

  def update_queue(queue_member_params)
    begin
      update_queue_members(queue_member_params)
      normalize_queue_member_orders
    rescue ActiveRecord::RecordInvalid
      return false
    end
    true
  end

  def normalize_queue_member_orders
    queue_members.each_with_index do |member, index|
      member.update! list_order: index + 1
    end
  end

  private

  def update_queue_members(params)
    QueueMember.transaction do
      params.each do |attrs|
        member = QueueMember.find attrs[:id]
        member.update_attributes! list_order: attrs[:position] if member.user == self
      end
    end
  end
end
