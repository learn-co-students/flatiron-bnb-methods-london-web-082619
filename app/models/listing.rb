class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  
  def booked_dates
    reservations.map { |res| (res.checkin..res.checkout).to_a}.flatten.uniq
  end

  def average_review_rating
    self.reviews.sum{|review| review.rating} / self.reviews.length.to_f
  end

end
