class Invite < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: 'User', foreign_key: 'inviter_id'
  belongs_to :invitee, class_name: 'User', foreign_key: 'invitee_id'

  validates_presence_of :email
  validates_presence_of :name
end
