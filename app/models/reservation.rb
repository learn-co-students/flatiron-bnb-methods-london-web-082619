class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  ###### Validations ######

  validate :checkin_and_checkout?,
           :checkout_after_checkin,
           :not_own_listing,
           :listing_available


  def checkin_and_checkout?
    # Checks the existence of checkin and checkout dates
    if checkin && checkout
      true
    else
      errors.add(:reservation, "requires a check-in and check-out date")
      false
    end
  end

  
  def checkout_after_checkin
    # Checks checkout date is after checkin date
    unless checkin_and_checkout? && checkin < checkout
      errors.add(:checkout, "date must be later than check-in date")
    end
  end


  def not_own_listing
    # Checks that the host doesn't own the listing being booked
    if guest == listing.host
      errors.add(:guest, "can't own the listing")
    end
  end


  def listing_available
    # Checks that the listing is available for the dates booked
    if checkin_and_checkout?
      if listing.booked?(checkin, checkout)
        errors.add(:listing, "is booked for these dates")
      end
    end
  end


  ###### Instance methods ######

  def duration
    # Return the duration of the reservation in days
    checkout - checkin
  end
  

  def total_price
    # Return the total price of the reservation
    duration * listing.price
  end

end
