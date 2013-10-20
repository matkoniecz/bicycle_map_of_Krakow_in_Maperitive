load "definitions.rb"
load "styles.rb"

#TODO handle cycleway=opposite (droga dwukierunkowa dla rowerzystów, dla reszty jednokierunkowa)
#TODO find and kill "unpaved" as surface

debug = false

ARGV.each do|a|
	if a == "debug"
		debug = true
	end
end

#highway=motorway ignored as not relevant
__no_access = "(access=private OR access=no)"
__cycleable = "((highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane) AND NOT #{__no_access})"
__typical_road = "(@isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, secondary_link, tertiary, tertiary_link, pedestrian, residential, living_street, unclassified)  AND NOT #{__no_access})"
__typical_road_accessible_to_bicycles = "((#{__typical_road} OR highway=track OR highway=service) AND NOT bicycle=no AND NOT service=parking_aisle)"
__separate_cycleway = "(((highway=cycleway AND NOT segregated = no AND NOT foot = yes AND NOT foot = designated))  AND NOT #{__no_access})"
__segregated_cycleway = "(((highway=cycleway AND segregated = yes) OR (bicycle=designated AND segregated = yes) OR (cycleway = lane))  AND NOT #{__no_access})"
__proper_surface = "(surface = asphalt OR smoothness = excellent OR smoothness = good OR smoothness = intermediate OR cycleway:surface=asphalt)"
__terible_surface = "(smoothness = bad OR smoothness = very_bad OR smoothness = horrible  OR smoothness = very_horrible OR smoothness = impassable)"
__cycleway = "("+__separate_cycleway + " OR " + __segregated_cycleway + ")"
__no_surface_info_for_main_part = "(surface=paved OR (NOT (surface) AND NOT (tracktype) AND NOT (smoothness)))"
__no_surface_info_for_lane = "(cycleway:surface=paved OR NOT cycleway:surface)"
__lame_cycleway = "(((bicycle=designated OR highway=cycleway) AND NOT #{__cycleway}) AND NOT #{__no_access})"
__contraflow = "((cycleway=opposite_lane) AND NOT #{__no_access})"
__unexpected_allowed_cycling = "((bicycle=yes) AND NOT " + __typical_road + " AND NOT highway=service AND NOT highway=track AND NOT #{__no_access})"
__unexpected_cycling_ban = "(bicycle=no AND #{__typical_road})"
__valid_bicycle_source_value = "(source:bicycle=sign OR source:bicycle=park_rules OR footway=sidewalk)" #footway=sidewalk is temporary as source:bicycle needs proper string for this status
def weird name, allowed
	returned = name
	allowed.each do |value|
		returned += " AND NOT #{name}=#{value}"
	end
	return "(#{returned})"
end
OK_surface_values = ["asphalt", "grass", "dirt", "compacted", "sett", "paved", "paving_stones", "gravel", "ground", "sand", "wood", "earth", "pebblestone", "concrete", "unpaved", "cobblestone"]
__weird_main_surface = weird("surface", OK_surface_values)
__weird_highway_value = weird("highway", ["motorway", "motorway_link", "trunk", "trunk_link", "primary", "primary_link", "secondary", "secondary_link", "tertiary", "tertiary_link", "pedestrian", "residential", "living_street", "unclassified", "service", "track", "footway", "cycleway", "steps", "path", "proposed", "construction", "bridleway"])
__weird_cycleway_surface = weird("cycleway:surface", OK_surface_values)
__bicycle_parking = "(amenity=bicycle_parking)"

puts get_top
puts "	lines"
puts "		cycleable road : #{__typical_road_accessible_to_bicycles}"
if debug
	puts "		weird highway value : #{__weird_highway_value}"
	puts "		weird cycleway value : cycleway AND NOT cycleway=lane AND NOT cycleway=opposite_lane AND NOT cycleway=no AND NOT cycleway=opposite"
	puts "		weird bicycle value : bicycle AND NOT bicycle=yes AND NOT bicycle=no AND NOT bicycle = designated AND NOT bicycle = dismount"
	puts "		weird tags : cycleway:right OR cycleway:left"
	puts "		weird surface value : #{__cycleable} AND (#{__weird_main_surface} OR #{__weird_cycleway_surface})"
	puts "		no_and_yes_bug : #{__cycleable} AND bicycle=no"
	puts "		crossing_as_way_rather_than_node_bug : highway = crossing"
	puts "		no oneway for bicycle instead of opposite_lane : \"oneway:bicycle\" = \"no\" AND NOT cycleway=opposite_lane"
	puts "		no_surface_info : (#{__cycleway} OR #{__lame_cycleway} OR #{__contraflow}) AND (#{__no_surface_info_for_main_part} AND #{__no_surface_info_for_lane})"
	puts "		no maxspeed info : (@isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, tertiary, unclassified) AND NOT maxspeed)"
	puts "		plus 50 maxspeed : (maxspeed > 50)"
	puts "		missing segregate : ((bicycle=designated OR highway=cycleway) AND (foot=yes OR foot=designated OR bicycle=foot OR highway=footway) AND NOT segregated)"
	puts "		weird segregate : (segregated AND NOT segregated=yes AND NOT segregated=no)"
	puts ""
end
puts "		proper cycleway : #{__cycleway} AND #{__proper_surface} AND NOT #{__terible_surface}"
puts "		proper cycleway with a bad surface : #{__cycleway} AND NOT #{__proper_surface} AND NOT #{__terible_surface}"
puts "		proper cycleway with a terrible surface : #{__cycleway} AND  #{__terible_surface}"
puts "		lame cycleway with a good surface: #{__lame_cycleway} AND #{__proper_surface} AND NOT #{__terible_surface}"
puts "		lame cycleway with a bad surface: #{__lame_cycleway} AND NOT #{__proper_surface}"
puts "		lame cycleway with a terrible surface: #{__lame_cycleway} AND #{__terible_surface}"
puts "		contraflow : #{__contraflow}"
puts "		bicycle allowed : #{__unexpected_allowed_cycling}"
puts "		unexpected cycling ban: #{__unexpected_cycling_ban}"
if debug
	puts "		bicycle unexpected status no source mentioned: (#{__unexpected_cycling_ban} OR #{__unexpected_allowed_cycling}) AND NOT #{__valid_bicycle_source_value}"
end
puts "	points"
__bicycle_crossing_way = "((#{__cycleway} OR #{__lame_cycleway} OR #{__unexpected_allowed_cycling}) AND NOT #{__contraflow} AND NOT (cycleway=lane AND #{__typical_road}))"
puts "		OK_bicycle_crossing : way[#{__bicycle_crossing_way}].node[highway=crossing AND (bicycle=yes OR bicycle = designated)]"
puts "		not_OK_bicycle_crossing : way[#{__bicycle_crossing_way}].node[highway=crossing AND bicycle=no]"
if debug
	puts "		not_defined_bicycle_crossing : way[#{__bicycle_crossing_way}].node[highway=crossing AND NOT bicycle=yes AND NOT bicycle=no AND NOT bicycle=designated]"
end
puts "	points, lines, areas"
if debug
	puts "		fixme : fixme AND fixme:type:bicycle=yes"
end
puts "	points, areas"
if debug
	puts "		bicycle_parking_no_capacity : #{__bicycle_parking} AND NOT (capacity)"
	puts "		bicycle_parking_no_type : #{__bicycle_parking} AND (NOT bicycle_parking OR (NOT (bicycle_parking=wall_loops) AND NOT (bicycle_parking=stands)))"
	puts ""
end
puts "		bicycle_parking : #{__bicycle_parking}"
puts "		bicycle shop : shop=bicycle"
puts "		drinking_water : amenity=drinking_water"

puts get_bottom_before_bicycle_styles 
puts get_bicycle_styles
puts get_bottom_after_bicycle_styles 
