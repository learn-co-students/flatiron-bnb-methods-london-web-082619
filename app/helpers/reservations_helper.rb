module ReservationsHelper
  # Instance methods
  
  def self.included(base)
    # Include and extend the base class
    base.extend(ReservationsHelperClassMethods)
  end


  def available_listings(checkin, checkout)
    # Return an array of listings available in a given date range
    self.listings.select do |listing| 
      !listing.booked?(DateTime.parse(checkin), DateTime.parse(checkout))
    end
  end
  

  def reservation_to_listing_ratio
    # Return the ratio of reservations to listings for the base location
    if self.listings.any?
      self.reservations.length / self.listings.length.to_f
    else
      0
    end
  end


  module ReservationsHelperClassMethods
    # Class methods

    def highest_ratio_res_to_listings
      # Return the instance of base with the highest ratio of reservations to listings
      self.all.max_by { |location| location.reservation_to_listing_ratio }
    end


    def most_res
      # Return the instance of base with the most reservations
      self.all.max_by { |location| location.reservations.length }
    end

  end

end