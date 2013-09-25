require 'rest_client'

exec('osmfilter.exe interpreter --drop="building=*" --drop="cuisine=pizza" --drop="amenity=arts_centre =public_building =nightclub =taxi =car_wash =veterinary =waste_basket =waste_disposal =dentist =clinic =vending_machine =townhall =bureau_de_change =doctors =fast_food =pub =restaurant =cafe =atm =bar =pharmacy =recycling =cinema =theatre =bank =parking =embassy =biergarten =post_office =post_box =board =place_of_worship =police =fuel =fire_station =hospital =library =university =college =telephone =school =kindergarten =bus_station =marketplace" --drop="railway=buffer_stop" --drop="historic=memorial =archaeological_site =monument =tomb =wayside_shrine" --drop="shop*" --drop="tourism=hostel =museum =hotel =information =guest_house" --drop-nodes="power=sub_station =station" --drop-nodes="tourism=attraction" --drop="natural=tree =cliff =sand" --drop="highway=proposed"  --drop-tags="highway=bus_stop =traffic_signals" --drop-tags="public_transport=stop_position" --drop-tags="railway=tram_stop" --drop="aeroway=helipad" --drop="leisure=*" --drop="public_transport=platform" --drop="landuse=*" --drop="barrier=*" --drop-tags="entrance=*" --drop-nodes="sport=equestrian =table_tennis =gymnastics" --drop-relations --drop-author --drop="emergency=fire_hydrant" --drop="tomb=tombstone" --drop-tags="addr:*" --keep-nodes="*=*" --keep-ways="*=*" -o=interpreter2') #filter

exec('osmfilter.exe interpreter2 --keep-nodes="*=*" --keep-ways="*=*" -o=smaller.osm') #second filtering pass, no idea why it is necessary
exit

text = RestClient.get(URI.escape("http://overpass-api.de/api/interpreter?data=(node(50,19.78,50.11,20.09);<;);out meta;"), :user_agent => "bulwersator@gmail.com").to_str
filename = "interpreter"
if File.exists?(filename)
	File.delete(filename)
end
f = File.new(filename, "w")
f.write text
f.close
