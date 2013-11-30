This project is a tool to process data from OpenStreetMap into map about cycling infrastructure in city Kraków, using program Maperitive. It may be useful for other locations but it is untested.

Retrieving mapa data fetches 140MB file. From http://wiki.openstreetmap.org/wiki/Overpass_API - "You can safely assume that you don't disturb other users when you do less than 10.000 queries per day or download less than 5 GB data per day.").

1a) to download map using ruby script:

run download.rb.

1b) to fetch map data without installed ruby:

Open http://overpass-api.de/query_form.html in web browser and paste following code in the first textarea:

(
  node(50,19.78,50.11,20.09);
  <;
);
out meta;

and press Querry. Name obtained file interpreter.osm and move to the repository.

2) To see map: run Maperitive.exe in folder Maperitive.

3) to modify rendering rules. Requires Ruby.

modify generate.rb and run generate.bat to generate a new version of .mrules files

#) In case of problems, feedback, ideas (including pull requests) involving this project - open issue on Github: https://github.com/Bulwersator/bicycle_map_of_Krakow/issues . In case of general OSM problems - folks at http://irc.openstreetmap.org/irc.cgi are extremely helpful.