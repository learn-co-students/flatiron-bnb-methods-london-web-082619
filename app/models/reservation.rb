class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_is_not_guest
  validate :only_book_if_available
  validate :checkin_before_checkout?

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    listing.price * self.duration
  end
  
  
  private
  
  def host_is_not_guest
    if self.guest_id != self.listing.host_id
      true
    else
    errors.add(:guest, "You can't book your own place you fool!")
    end
  end

  def only_book_if_available 
    date_range = (self.checkin..self.checkout)
    self.listing.booked_dates.each do |date|
      if date_range === date
        errors.add(:dates, "Sorry, this listing is not available on these dates")
      else
        true
      end
    end
  end

  def checkin_before_checkout?
    if self.checkin >= self.checkout
      errors.add(:dates, "You can't leave before you arrive!")
    else
      true
    end
  end

  def checkin_and_checkout?
    if self.checkin.blank? || self.checkout.blank?
      errors.add(:dates, "You must fill in checkin and checkout")
    else
      true
    end
  end


end
