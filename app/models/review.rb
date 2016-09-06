class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :video
  validates_presence_of :author
  validates_presence_of :rating

  validates_numericality_of :rating,
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
end
