class User < ActiveRecord::Base

  # As a guest
  has_many :reviews, foreign_key: :guest_id
  has_many :trips, foreign_key: :guest_id, class_name: :Reservation
  has_many :trip_listings, through: :trips, source: :listing
  has_many :hosts, through: :trip_listings, foreign_key: :host_id

  #As a host
  has_many :listings, foreign_key: :host_id
  has_many :reservations, through: :listings
  has_many :guests, through: :reservations, class_name: :User
  has_many :host_reviews, through: :listings, source: :reviews

  # def guests
  #   self.reservations.map { |reservation| reservation.guest }.uniq
  # end

  # def hosts
  #   self.trips.map { |trip| trip.listing.host }.uniq
  # end

  # def host_reviews
  #   self.listings.map { |listing| listing.reviews }.flatten
  # end


end
