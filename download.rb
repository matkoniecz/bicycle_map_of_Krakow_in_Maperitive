require 'rest_client'
puts "downloading: start"
text = RestClient.get(URI.escape("http://overpass-api.de/api/interpreter?data=(node(50,19.78,50.11,20.09);<;);out meta;"), :user_agent => "bulwersator@gmail.com").to_str
puts "downloading: end"

filename = "interpreter.osm"
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