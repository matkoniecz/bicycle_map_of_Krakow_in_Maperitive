require 'rest_client'

downloading = true
ARGV.each do |name|
	if name == "filter"
		downloading = false
	end
end

if downloading
	puts "downloading: start"
	text = RestClient.get(URI.escape("http://overpass-api.de/api/interpreter?data=(node(50,19.78,50.11,20.09);<;);out meta;"), :user_agent => "bulwersator@gmail.com").to_str
	puts "downloading: end"

	filenames = ["interpreter", "interpreter.osm"]
	filenames.each {|filename|
		if File.exists?(filename)
			puts "deleting old file: start"
			File.delete(filename)
			puts "deleting old file: end"
		end
		puts "saving new file: start"
		f = File.new(filename, "w")
		f.write text
		f.close
		puts "saving new file: end"
	}
end

puts "filtering, I phase: start"
system('osmfilter.exe interpreter --drop="inscription=*" --drop="building:use=garage =apartments" --drop-tags="elevator=" --drop-tags="elevator:level=" --drop-tags="wikipedia=" --drop-tags="name:*" --drop-tags="building:*" --drop-tags="roof:*" --drop-tags="wheelchair=yes =no" --drop="sport=archery =shooting =athletics =beachvolleyball =soccer =karting =equestrian =table_tennis =gymnastics =volleyball"  --drop="designation=*" --drop="designation==house" --drop="building=nursery =apartment block =wier =semidetached =hall =construction =detached =terrace =train_station =synagogue =farm =convent =tower =hangar =retail =shed =farm_auxiliary =bridge =hotel =cloister =roof =monastery =church =warehouse =industrial =garages =garage =greenhouse =dormitory =office =house =public =chapel =residential =apartments =hospital =apartment block" --drop="building:part=*" --drop="cuisine=pizza" --drop="amenity=insurance_agent =estate_agent =casino =language_school =auction_house =table =courthouse =food_court =garage =social_facility =community_centre =driving_school =ice_cream =brothel =fountain =toilets =prison =swimming_pool =bench =parking_space =parking_entrance =arts_centre =public_building =nightclub =taxi =car_wash =veterinary =waste_basket =waste_disposal =dentist =clinic =vending_machine =townhall =bureau_de_change =doctors =fast_food =pub =restaurant =cafe =atm =bar =pharmacy =recycling =cinema =theatre =bank =parking =embassy =biergarten =post_office =post_box =board =place_of_worship =police =fire_station =hospital =library =university =college =telephone =school =kindergarten =bus_station =marketplace" --drop="railway=buffer_stop" --drop="tower:type" --drop-tags="historic=building" --drop="historic=castle =fort =fortification =wayside_cross =ruins =memorial =archaeological_site =monument =tomb =wayside_shrine" --drop="advertising=column" --drop="shop=farm =yes =cosmetics =pawnbroker =video =cobbler =pastry =beauty =general =crafts =commodities =second_hand =ice_cream =antiques =watchmaker =herbs =organic =funeral_directors =musical_instrument video =tyres =laundry =newsagent =hardware =car_parts =tailor =electronics =erotic =frame =sports =fabric =mobile_phone =hifi =copyshop =gift =department_store =boutique =motorcycle =garden_centre =butcher =mall =jewelry =toys =vacant =variety_store =paint =curtain =clothes =travel_agency =beverages =books =alcohol =doityourself =hairdresser =stationery =confectionery =kiosk =computer =supermarket =shoes =optician =pet =florist =outdoor =chemist =greengrocer =convenience =furniture =car =car_repair =bakery" --drop="tourism=artwork =picnic_site =viewpoint =caravan_site =gallery =camp_site =hostel =museum =hotel =motel =information =guest_house" --drop="power=cable_distribution_cabinet =cable =station =tower =minor_line =line =sub_station" --drop-tags="tourism=attraction" --drop="natural=tree*" --drop="natural=mud =wetland =grassland =cave_entrance =scrub =ridge =cliff =sand =beach" --drop="highway=motorway_junction =speed_camera =milestone =proposed"  --drop-tags="highway=turning_circle =bus_stop =traffic_signals =give_way =stop" --drop-tags="traffic_signals:sound" --drop-tags="railway=tram_stop =halt" --drop="aeroway=holding_position =terminal =runway =helipad" --drop="public_transport=station =platform" --drop="landuse=vineyard =greenhouse_horticulture =basin =conservation =recreation_ground =farmyard =education =railway =cemetery =religious =farmland =retail =landfill =quarry =industrial =residential =meadow =construction =brownfield =village_green =military =allotments =grass =greenfield =commercial =garages" --drop="barrier=*" --drop-tags="heritage=*" --drop-tags="heritage:operator=*" --drop-tags="ref:nid=*" --drop-tags="email=*" --drop-tags="entrance=*" --drop-tags="office=*" --drop-relations --drop-author --drop="emergency=fire_water_pond =aed =fire_hydrant" --drop="shelter=" --drop="route=" --drop="highway=street_lamp" --drop="railway=disused =abandoned =platform" --drop="tomb=tombstone" --drop-tags="addr:*" --drop-tags="embankment=*" --drop-tags="created_by=*" --drop-tags="height=" --drop-tags="phone=*" --drop-tags="url=*" --drop-tags="website=*" --drop="construction=planned =residential" --drop-tags="note=*" --drop-tags="building=yes" --drop-tags="building=commercial" --drop-tags="source=*" --drop-tags="source:building=*"  --drop-tags="boundary=*" --drop="man_made=works =table =pier =tower =cross =reservoir_covered =silo =pipeline =wastewater_plant =monitoring_station =chimney" --drop="cemetery=sector"  --drop="military=barracks =bunker" --drop-tags="old_name=" --drop-tags="highway=elevator" --drop-tags="alt_name="  --drop-tags="loc_name=" --drop-tags="public_transport=stop_position" --drop-tags="bus=yes" --drop-tags="tram=yes" --drop="waterway=weir =lock_gate =drain =ditch" --drop-tags="tactile_paving" --drop-tags="bus_numbers=" --drop-tags="ruins=yes" --drop="traffic_sign=city_limit" --drop-tags="wood=deciduous =mixed" --drop="playground=sandpit"  --drop="man_made=water_well =water_works" --drop-ways="railway=tram" --drop="place=suburb" --drop="leisure=ice_rink =stadium =nature_reserve =playground =track =sports_centre =pitch =swimming_pool =common" --keep-nodes="*=*" --keep-ways="*=*" -o=interpreter2') #filter
puts "filtering, I phase: end"
puts "filtering, II phase: start"
system('osmfilter.exe interpreter2 --keep-nodes="*=*" --keep-ways="*=*"  --drop-tags="layer=" -o=smaller.osm') #second filtering pass, no idea why it is necessary #note  --drop-tags="layer=" - to make cycleways always on the top
puts "filtering, II phase: end"


puts "generating file of data not used and not filtered out: start"
#amenity  =fuel - temporary, instead of amenity = compressed_air
#significant part of name= should be dropped in a previous filtering
#traffic_calming=, access=, opening_hours=, railway=level_crossing =crossing amenity=bicycle_rental, noexit=yes are currently not used, but probably should be
#man_made=water_well (???)
system('osmfilter.exe smaller.osm --drop-tags="opening_hours="  --drop-tags="access" --drop-tags="noexit=yes" --drop-tags="traffic_calming=table =bump"  --drop="man_made=water_well" --drop="amenity=fuel =compressed_air =bicycle_rental" -o=test1') #filtering out what will be used
system('osmfilter.exe test1  --drop="crossing=" --drop="highway=crossing" --drop-nodes="place=city =suburb =neighbourhood =locality" --drop="railway=level_crossing =crossing" --drop-tags="fixme=" --drop-tags="FIXME=" --drop-tags="fixme:type:bicycle=" --drop-tags="name=" --drop-ways="railway=rail" --drop-ways="highway=*" --drop-ways="waterway=river"  --drop="aeroway=apron" --drop="aeroway=taxiway" --drop="natural=water =wood" --drop="waterway=riverbank =stream =dock =canal" --drop="leisure=park =garden" --drop-tags="landuse=forest =orchard =reservoir" --drop="amenity=bicycle_parking =drinking_water" --drop="shop=bicycle"  --keep-nodes="*=*" --keep-ways="*=*" -o=test2') #filtering out used
system('osmfilter.exe test2 --keep-nodes="*=*" --keep-ways="*=*" -o=test3') #second filtering pass, no idea why it is necessary
system('osmfilter.exe test3 --keep-nodes="*=*" --keep-ways="*=*" -o=test.osm') #third filtering pass, no idea why it is necessary
puts "generating file of data not used and not filtered out: end"
