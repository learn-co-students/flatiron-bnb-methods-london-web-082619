class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def reservations
    self.listings.map{ |listing| listing.reservations }.flatten
  end

  def city_openings(span_start, span_end)
    #should return all of the Listing objects that are available for the entire span that is inputted.  
    self.listings.select{ |listing| listing.available?(span_start, span_end) == true }
  end

  def self.highest_ratio_res_to_listings 
    # should return the City that is "most full". What that means is it has the highest amount of reservations per listing.
    self.all.max_by{ |city| city.reservations.length / city.listings.length } 
  end

  def self.most_res 
    # should return the City with the most total number of reservations, no matter if they are all on one listing or otherwise.
    self.all.max_by{ |city| city.reservations.length }
  end

end

