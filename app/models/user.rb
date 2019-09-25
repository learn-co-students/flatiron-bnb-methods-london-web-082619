class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def guests
      self.reservations.each.map{ |reservation| reservation.guest }
  end

  def hosts
      my_reservations = Reservation.all.select{ |reservation| reservation.guest_id == self.id }
      my_reservations.map{ |reservation| Listing.find(reservation.listing_id).host }.uniq 
  end

  def host_reviews
      self.listings.each.map{ |listing| listing.reviews }.flatten
  end

end
