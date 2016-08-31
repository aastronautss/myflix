class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.order(:created_at).where('title ILIKE ?', "%#{search_term}%")
  end
end