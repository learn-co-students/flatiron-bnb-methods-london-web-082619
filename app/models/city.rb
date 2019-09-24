class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    date_range = (Date.parse(start_date)..Date.parse(end_date))
    listings.map do |listing|
      available = true
      listing.booked_dates.each do |date|
        if date_range === date
          available = false
        end
      end
      listing if available
    end
  end

  def ratio_res_to_listings
    self.reservations.length.to_f / self.listings.length
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by{|city| city.ratio_res_to_listings}
  end

  def self.most_res
    self.all.max_by{|city| city.reservations.length}
  end

end

