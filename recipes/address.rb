## Ruby on Rails

HOST_OS = RbConfig::CONFIG['host_os']
say_wizard "Your operating system is #{HOST_OS}."
say_wizard "You are using Ruby version #{RUBY_VERSION}."
say_wizard "You are using Rails version #{Rails::VERSION::STRING}."

repo = 'https://raw.github.com/cenglert/application_builds/master/'
add_gem 'geocoder'



#Building 
copy_from_repo 'app/models/address.rb', :repo => repo
copy_from_repo 'app/models/city.rb', :repo => repo
copy_from_repo 'app/models/region.rb', :repo => repo
copy_from_repo 'app/models/country.rb', :repo => repo


#Copy address migrations
copy_from_repo 'db/migrate/20130714194504_create_cities.rb',:repo => repo
copy_from_repo 'db/migrate/20130714194505_create_regions.rb',:repo => repo
copy_from_repo 'db/migrate/20130714194506_create_countries.rb',:repo => repo
copy_from_repo 'db/migrate/20130714194507_create_addresses.rb',:repo => repo

#Copy address seed data
append_to_file 'db/seeds.rb', "require 'rubygems'\nrequire 'seed_file'\nRails.root.join('db/seeds').children.each do |child|\n\n  begin\n    if child.basename.to_s != '.svn' then\n    SeedFile.import(child.to_s)\n    end\n rescue NameError => e\n    abort '!! '\n  end\n end\n" #, :after => "﻿#   Mayor.create(name: 'Emanuel', city: cities.first)"
copy_from_repo 'lib/seed_file.rb', :repo => repo
copy_from_repo 'db/seeds/Cities.csv', :repo => repo
copy_from_repo 'db/seeds/Countries.csv', :repo => repo
copy_from_repo 'db/seeds/Regions.csv', :repo => repo


__END__

name: address
description: "Add address functionality to your applicaiton"
author: Chris Englert

run_after: []
category: configuration