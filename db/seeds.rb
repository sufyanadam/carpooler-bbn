# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PickupSpot.create([
  {:name => "Alameda (Encinal & Park Ave)", :lat => 37.762074, :lng => -122.243378},
  {:name => "Alameda (Webster & Santa Clara)", :lat => 37.773331, :lng => -122.276764},
  {:name => "Albany (Pierce St)", :lat => 37.900124, :lng => -122.30928},
  {:name => "Berkeley (NB BART)", :lat => 37.874245, :lng => -122.282585},
  {:name => "El Cerrito Del Norte", :lat => 37.921139, :lng => -122.317612},
  {:name => "Emeryville (Christie)", :lat => 37.843594, :lng => -122.295723},
  {:name => "Emeryville Marina", :lat => 37.837006, :lng => -122.304863},
  {:name => "Fairfield Trns Cntr", :lat => 38.248501, :lng => -122.069},
  {:name => "Hercules Trns Cntr", :lat => 38.01334, :lng => -122.272133},
  {:name => "Lafayette BART", :lat => 37.893425, :lng => -122.123795},
  {:name => "Moraga Way", :lat => 37.836021, :lng => -122.131409},
  # PickupSpot.create!(:name => "Oakland (Lakeshore & Grand)")
  # PickupSpot.create!(:name => "Oakland Grand & Perkins")
  # PickupSpot.create!(:name => "Oakland (Claremone & College)")
  # PickupSpot.create!(:name => "Oakland (Park & Hollywood)")
  # PickupSpot.create!(:name => "Oakland (Park & Hampel)")
  #  PickupSpot.create!(:name => "Oakland (Fruitvale & Montana)")
  #  PickupSpot.create!(:name => "Oakland (Hudson & Claremont)")
  #  PickupSpot.create!(:name => "Oakland (Oakland & Monte Vista)")
  #  PickupSpot.create!(:name => "Oakland (MacArthur & High)")
  {:name => "Orinda BART", :lat => 37.878522, :lng => -122.183005},
  {:name => "Piedmont (Oakland Ave)", :lat => 37.825287, :lng => -122.235672},
  {:name => "Richmond Pkwy", :lat => 37.986526, :lng => -122.31633},
  {:name => "Vallejo (Curtola Pkwy)", :lat => 38.092869, :lng => -122.237366},
  {:name => "San Francisco", :lat => 37.789101, :lng => -122.395195}
])

DestinationSpot.create([
  {:name => "San Francisco"},
  {:name => "Hercules"},
  {:name => "Richmond Parkway"},
  {:name => "Fairfield"},
  {:name => "Vallejo"}
])