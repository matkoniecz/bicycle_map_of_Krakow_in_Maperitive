This project is a tool to process data from OpenStreetMap into map about cycling infrastructure in city Kraków, using program Maperitive. It may be useful for other locations but it is untested.

In the first place we need map data from OSM. It seems that using Overpass API is the recommended and efficient way of aquiring it, and simple way of using this service is to visit http://overpass-api.de/query_form.html and paste following code in the first textarea (area contains Kraków, code is from http://wiki.openstreetmap.org/wiki/Overpass_API/Language_Guide#Simplest_possible_map_call):

(
  node(50,19.78,50.11,20.09);
  <;
);
out meta;

and press Querry (from http://wiki.openstreetmap.org/wiki/Overpass_API - "You can safely assume that you don't disturb other users when you do less than 10.000 queries per day or download less than 5 GB data per day."). Around 140MB file will be downloaded. To reduce size, it may be filtered with osmfilter, reducing filesize to about 21 MB and - what is really important, by removal unneded data it makes next steeps less laggy and it is easier to notice map features that may be useful.

Osmfilter for Windows is part of repository, and filter.bat is responsible for filtering. It should be easy to make changes necessary run it on Linux. It is also possible to skip this step, but Maperitive will need be around six times slower.

Now file is ready for processing with Maperitive. Open this program, disable default backround (click on star in right bottom panel titled "Map sources") use File|Open map sources and import prepared file (smaller.osm). Than switch to ruleset that is main part of this repository, using following command: http://maperitive.net/docs/Commands/UseRuleset.html (this repository may reside in rules folder resulting in use-ruleset location=rules/biking.mrules as-alias=biking command)

In case with OSM problems - folks at http://irc.openstreetmap.org/irc.cgi are extremely helpful.