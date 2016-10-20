class Invite < ActiveRecord::Base
  before_create :generate_token

  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :invitee, class_name: 'User', foreign_key: 'invitee_id'

  validates_presence_of :email
  validates_presence_of :name

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def expire_token
    self.update_column :token, nil
  end
end
