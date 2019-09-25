class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, :listing_id, {presence: true}
  
  validate :reservation_checks
  validate :dates_available?


  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.listing.price * self.duration
  end

  #VALIDATION CHECKS

  def dates_available?
    listing = Listing.find(listing_id)
    if checkin == nil || checkout == nil
      return false
    else
      if !listing.available?(checkin, checkout)
        self.errors.add(:listing, "Listing not available for these dates")
      end
    end
  end


  def reservation_checks
    if !checkin || !checkout
      return false
    end
    listing = Listing.find(listing_id)
    unless (guest_id != listing.host_id) && (checkin < checkout) && (checkin != checkout)
      self.errors.add(:listing, "Not a valid reservation")
      return false
    end
  end


end
