class Region < ActiveRecord::Base
  has_many :cities
  belongs_to :country
  attr_accessible :region, :code, :adm1code
end
