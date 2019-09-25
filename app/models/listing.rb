class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  after_create :change_host_status
  before_destroy :check_host_status

  validates :address, { presence: true}
  validates :listing_type, { presence: true}
  validates :title, { presence: true}
  validates :description, { presence: true}
  validates :price, { presence: true}
  validates :neighborhood_id, { presence: true}

  def reviews
    self.reservations.map{ |reservation| reservation.review }
  end

  def average_review_rating
    self.reviews.sum{ |review| review.rating }.to_f / self.reviews.length
  end

  def change_host_status
    user = User.find(self.host_id)
    user.host = true
    user.save
  end

  def check_host_status
    if self.host.listings.length == 1
      user = User.find(self.host_id)
      user.host = false
      user.save
    else
      #do nothing
    end
  end

  #returns true when listing is available
  def available?(span_start, span_end)
    if span_start.class != Date 
      start_date = Date.parse(span_start) 
    else 
      start_date = span_start
    end
    if span_end.class != Date
      end_date = Date.parse(span_end)
    else
      end_date = span_end
    end
    if self.reservations.any?{ |reservation| reservation.checkout > start_date && reservation.checkout < end_date || reservation.checkin > start_date && reservation.checkout < end_date || reservation.checkin > start_date && reservation.checkin < end_date } === false
      return true
    else 
      false
    end
  end



end
