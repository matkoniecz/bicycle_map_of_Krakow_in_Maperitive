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

areas = "landuse=reservoir waterway=river =riverbank =stream =dock =canal natural=water =wood leisure=park =garden landuse=forest =orchard aeroway=apron aeroway=taxiway natural=water"
command = '--keep-relations="' + areas + '" --keep-ways="highway=motorway =motorway_link =trunk =trunk_link =primary =primary_link =secondary =secondary_link =tertiary =tertiary_link =pedestrian =residential =living_street =unclassified =service =track =cycleway railway=rail  bicycle=yes bicycle=designated ' + areas + '" --keep-nodes="highway=crossing fixme=* FIXME=* amenity=bicycle_parking shop=bicycle amenity=drinking_water" --drop-ways="highway=proposed access=private access=no" --drop-tags="source=*"'

puts "producing filtered file"
system("osmfilter.exe interpreter #{command}  -o=tmp")
system("osmfilter.exe tmp #{command}  -o=tmp2")
system("osmfilter.exe tmp2 #{command}  -o=filtered.osm")
puts "converting to geojson"
system("osmtogeojson filtered.osm > filtered.geojson")