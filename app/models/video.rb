class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name ['myflix', Rails.env].join('_')

  belongs_to :category
  has_many :reviews, -> { order('created_at desc') }, dependent: :destroy
  has_many :queue_members, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.order(:created_at).where('title ILIKE ?', "%#{search_term}%")
  end

  def rating
    ratings = reviews.map &:rating
    unless ratings.empty?
      (ratings.inject(:+) / ratings.length.round(1)).round(1)
    else
      nil
    end
  end
end
