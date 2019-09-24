class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :make_host
  after_destroy :make_user

  def make_host
    self.host.update(host: true)
  end

  def make_user
    self.host.update(host: false) if self.host.listings.none?
  end

  def average_review_rating
    ratings = self.reviews.map { |review| review.rating }
    total_rating = ratings.reduce(:+)
    total_rating.to_f / ratings.length
  end

  def booked?(checkin, checkout)
    self.reservations.any? do |reservation|
      reservation.checkin < checkout &&
      reservation.checkout > checkin
    end
  end

end
