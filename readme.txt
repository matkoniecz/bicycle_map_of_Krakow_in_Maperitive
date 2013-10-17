This project is a tool to process data from OpenStreetMap into map about cycling infrastructure in city Kraków, using program Maperitive. It may be useful for other locations but it is untested.

1) to generate map with updated data from OSM, using web browser

Go to http://overpass-api.de/query_form.html and paste following code in the first textarea:

(
  node(50,19.78,50.11,20.09);
  <;
);
out meta;

and press Querry. Around 140MB file will be downloaded (from http://wiki.openstreetmap.org/wiki/Overpass_API - "You can safely assume that you don't disturb other users when you do less than 10.000 queries per day or download less than 5 GB data per day."). Now rename so that extension will be osm. Now install Maperitive. Open this program, disable default backround (click on star in right bottom panel titled "Map sources") use File|Open map sources and import prepared file. Than switch to ruleset that is main part of this repository, using following command: http://maperitive.net/docs/Commands/UseRuleset.html (this repository may reside in rules folder resulting in 
	use-ruleset location=rules/cyclemap/Biking.mrules as-alias=biking
	use-ruleset location=rules/cyclemap/BikingDebug.mrules as-alias=biking_debug
commands).

2) to download and filter map using ruby script (it makes map generation multiple times faster). Requires Ruby, tested on WIndows 7.

run download.rb.

3) to modify rendering rules. Requires Ruby.

modify and run generate.rb to generate a new version of .mrules file

#) In case of problems, feedback, ideas (including pull requests) involving this project - open issue on Github (). In case of OSM problems - folks at http://irc.openstreetmap.org/irc.cgi are extremely helpful.

*) Thanks to Igor Brejc and Michael for original .mrules file released under the Creative Commons Attribution-ShareAlike 3.0 License (http://creativecommons.org/licenses/by-sa/3.0/).