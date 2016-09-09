class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at desc') }, dependent: :destroy
  has_many :queue_members, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true


  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.order(:created_at).where('title ILIKE ?', "%#{search_term}%")
  end
end
