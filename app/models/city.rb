class City < ActiveRecord::Base
  belongs_to :region
  has_many :addresses
  attr_accessible :city, :latitude, :longitude, :timezone, :dma_id, :county, :code,:country_id,:region_id,:region
  def city_location
    "#{self.city}, #{self.region.code}, #{self.region.country.name}"
  end
end
