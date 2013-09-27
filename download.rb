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

	filename = "interpreter"
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
end

puts "filtering, I phase: start"
#amenity  =fuel - temporary, instead of amenity = compressed_air
system('osmfilter.exe interpreter --drop="sport=soccer =karting =equestrian =table_tennis =gymnastics =volleyball" --drop="building=*" --drop="building:part=*" --drop="cuisine=pizza" --drop="amenity=prison =swimming_pool =bench =parking_space =parking_entrance =arts_centre =public_building =nightclub =taxi =car_wash =veterinary =waste_basket =waste_disposal =dentist =clinic =vending_machine =townhall =bureau_de_change =doctors =fast_food =pub =restaurant =cafe =atm =bar =pharmacy =recycling =cinema =theatre =bank =parking =embassy =biergarten =post_office =post_box =board =place_of_worship =police =fire_station =hospital =library =university =college =telephone =school =kindergarten =bus_station =marketplace" --drop="railway=buffer_stop" --drop="tower:type" --drop="historic=wayside_cross =ruins =memorial =archaeological_site =monument =tomb =wayside_shrine" --drop="shop=confectionery =kiosk =computer =supermarket =shoes =optician =pet =florist =greengrocer =convenience =furniture =car =car_repair =bakery" --drop="tourism=camp_site hostel =museum =hotel =information =guest_house" --drop="power=sub_station" --drop-nodes="tourism=attraction" --drop="natural=tree* =cliff =sand" --drop="highway=milestone =proposed"  --drop-tags="highway=turning_circle =bus_stop =traffic_signals" --drop-tags="railway=tram_stop" --drop="aeroway=runway =helipad" --drop="leisure=*" --drop="public_transport=platform" --drop="landuse=*" --drop="barrier=*" --drop-tags="entrance=*" --drop-relations --drop-author --drop="emergency=fire_hydrant" --drop="shelter=" --drop="route=" --drop="highway=street_lamp" --drop="railway=disused" --drop="tomb=tombstone" --drop-tags="addr:*" --drop-tags="embankment=*" --drop-tags="created_by=*" --drop-tags="url=*" --drop-tags="construction=planned" --drop-tags="source=*"  --drop-tags="boundary=*" --drop="man_made=monitoring_station =chimney" --drop="cemetery=sector" --keep-nodes="*=*" --keep-ways="*=*" -o=interpreter2') #filter
puts "filtering, I phase: end"
puts "filtering, II phase: start"
system('osmfilter.exe interpreter2 --keep-nodes="*=*" --keep-ways="*=*" -o=smaller.osm') #second filtering pass, no idea why it is necessary
puts "filtering, II phase: end"


puts "generating file of data not used and not filtered out: start"
system('osmfilter.exe smaller.osm --drop="crossing=" --drop="highway=crossing" -o=test1') #filtering out what will be used
system('osmfilter.exe test1 --drop-ways="railway=rail" --drop-ways="railway=tram" --drop-ways="highway=*" --drop-ways="waterway=river"  --drop="aeroway=apron" --drop="aeroway=taxiway" --drop="natural=water" --drop="waterway=riverbank =stream" --drop="amenity=bicycle_parking" -o=test2') #filtering out used
system('osmfilter.exe test2 --keep-nodes="*=*" --keep-ways="*=*" -o=test.osm') #second filtering pass, no idea why it is necessary
puts "generating file of data not used and not filtered out: end"
