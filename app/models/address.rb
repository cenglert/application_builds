class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  belongs_to :city
  attr_accessible :street_address,:street_address_two, :apartment_number, :postal_code, :city_id, :latitude, :longitude, :active,:addressable_id, :addressable_type, :country_id, :region_id
  #validates :street_address,:presence => {:message => 'You\'ll have to add the street address before we can save this'}
  geocoded_by :full_street_address
  before_save :geocode
  #after_validation :geocode
  #what the deuce?
  
  def full_street_address
    if self.city_id || self.city
      
      city = City.find(:first,:conditions => {:city => self.city_id}) || self.city
      "#{self.street_address},#{self.postal_code},#{city.city},#{city.region.code},#{city.region.country.name}"  || ""
    else
      ""
    end
  end
end

