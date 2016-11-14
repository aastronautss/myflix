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

  def as_indexed_json(options = {})
    as_json only: [:title, :description],
      include: { reviews: { only: :body } },
      methods: [:rating]
  end

  def self.search(q, options = {})
    search_definition = {
      query: {
        multi_match: {
          query: q,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }

    if q.present? && options[:reviews].present?
      search_definition[:query][:multi_match][:fields] << "reviews.description"
    end

    if options[:rating_from].present? || options[:rating_to].present?
      lower_bound = options[:rating_from] ? options[:rating_from].to_f : 0
      upper_bound = options[:rating_to] ? options[:rating_to].to_f : 5

      search_definition[:filter] = {
        range: {
          rating: {
            gte: lower_bound,
            lte: upper_bound
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end

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
