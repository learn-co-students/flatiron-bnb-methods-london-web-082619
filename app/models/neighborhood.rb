class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def reservations
    self.listings.map{ |listing| listing.reservations }.flatten
  end

  def neighborhood_openings(span_start, span_end)
    #should return all of the Listing objects that are available for the entire span that is inputted.  
    self.listings.select{ |listing| listing.available?(span_start, span_end) == true }
  end

  def self.highest_ratio_res_to_listings 
    # should return the Neighborhood that is "most full". What that means is it has the highest amount of reservations per listing.
    has_listings = self.all.select{ |neighborhood| neighborhood.listings.length > 0 }
    has_listings.max_by{ |neighborhood| neighborhood.reservations.length / neighborhood.listings.length } 
  end

  def self.most_res 
    # should return the City with the most total number of reservations, no matter if they are all on one listing or otherwise.
    self.all.max_by{ |neighborhood| neighborhood.reservations.length }
  end


end
