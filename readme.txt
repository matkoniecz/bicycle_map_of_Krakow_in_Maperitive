This project is a tool to process data from OpenStreetMap into map about cycling infrastructure in city Kraków, using program Maperitive. It may be useful for other locations but it is untested.

In the first place we need map data from OSM. It seems that using Overpass API is the recommended and efficient way of aquiring it, and simple way of using this service is to visit http://overpass-api.de/query_form.html and paste following code in the first textarea (area contains Kraków, code is from http://wiki.openstreetmap.org/wiki/Overpass_API/Language_Guide#Simplest_possible_map_call):

(
  node(50,19.78,50.11,20.09);
  <;
);
out meta;

and press Querry. Around 140MB file will be downloaded. To reduce size, it may be filtered with osmfilter, reducing filesize to about 50 MB and - what is really important, by removal unneded data it makes next steeps less laggy and it is easier to notice map features that may be useful.

osmfilter interpreter --drop="building=*" --drop="amenity=fast_food =pub =restaurant =cafe =atm =bar =pharmacy =recycling =cinema =theatre =bank =parking =embassy =biergarten =post_office =post_box =board =place_of_worship =police =fuel =fire_station =hospital =library =university =college =telephone =school =kindergarten =bus_station" --drop="historic=memorial =archaeological_site" --drop="shop*" --drop="tourism=hostel =museum =hotel =information =guest_house =attraction" --drop="natural=tree =cliff =sand" --drop="highway=steps" --drop="highway=proposed"  --drop-tags="highway=bus_stop =traffic_signals" --drop-tags="public_transport=stop_position" --drop-tags="railway=tram_stop" --drop="aeroway=helipad" --drop="leisure=*" --drop="public_transport=platform" --drop="landuse=*" --drop="barrier=*" --drop-relations --drop-author -o=smaller.osm

//osmfilter - is it possible to filter out "highway=footway" but keep ones with "bicycle=yes"?

Now file is ready for processing with Maperitive. Open this program, disable default backround (click on star in right bottom panel titled "Map sources") use File|Open map sources and import prepared file (smaller.osm). Than switch to ruleset that is main part of this repository, using following command: http://maperitive.net/docs/Commands/UseRuleset.html

In case with OSM problems - folks at http://irc.openstreetmap.org/irc.cgi are extremely helpful.