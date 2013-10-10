class Country < ActiveRecord::Base
  has_many :regions
  attr_accessible :country, :fips104, :iso2, :iso3, :ison, :internet, :capitol, :map_reference, :nationality_singular, :nationality_plural, :currency, :currency_code, :population, :title, :comment
end
