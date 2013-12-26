load "styles.rb"

debug = false
heavy_debug = false

ARGV.each do|a|
	if a == "debug"
		debug = true
	end
	if a == "heavy_debug"
		heavy_debug = true
		debug = true
	end
end

mtb_route = "(mtb:scale AND NOT mtb:scale=0 AND NOT mtb:scale=0-)"
private_property = "(access=private OR access=no)" 
no_access = "(#{private_property} OR #{mtb_route})"
cycleable = "((highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane) AND NOT #{no_access}  AND NOT area:highway)"
motorway = "(highway=motorway OR highway=motorway_link OR highway=trunk OR highway=trunk_link)"
road_high_traffic = "(@isOneOf(highway, primary, primary_link, secondary, secondary_link) AND NOT #{no_access})"
road_normal_traffic = "(@isOneOf(highway, tertiary, tertiary_link, residential, unclassified) AND NOT #{no_access})"
road_low_traffic = "((highway=service OR highway=living_street OR highway=track) AND NOT service=parking_aisle AND NOT #{no_access})"
typical_road = "(#{road_high_traffic} OR #{road_normal_traffic} OR #{road_low_traffic})"
typical_road_accessible_to_bicycles = "(#{typical_road} AND NOT bicycle=no)"
high_traffic_road_accessible_to_bicycles = "((#{road_high_traffic}) AND NOT bicycle=no AND NOT #{no_access})"
normal_traffic_road_accessible_to_bicycles = "((#{road_normal_traffic}) AND NOT bicycle=no AND NOT #{no_access})"
low_traffic_road_accessible_to_bicycles = "((#{road_low_traffic}) AND NOT bicycle=no AND NOT #{no_access})"
separate_cycleway = "(((highway=cycleway AND NOT segregated = no AND NOT foot = yes AND NOT foot = designated))  AND NOT #{no_access})"
segregated_cycleway = "(((highway=cycleway AND segregated = yes) OR (bicycle=designated AND segregated = yes) OR (cycleway = lane))  AND NOT #{no_access})"
proper_surface = "(surface = asphalt OR smoothness = excellent OR smoothness = good OR smoothness = intermediate OR cycleway:surface=asphalt)"
terible_surface = "(smoothness = bad OR smoothness = very_bad OR smoothness = horrible  OR smoothness = very_horrible OR smoothness = impassable)"
cycleway = "("+separate_cycleway + " OR " + segregated_cycleway + ")"
no_surface_info_for_main_part = "(surface=paved OR surface=unpaved OR (NOT (surface) AND NOT (tracktype) AND NOT (smoothness)))"
no_surface_info_for_lane = "(cycleway:surface=paved OR cycleway:surface=unpaved OR NOT cycleway:surface)"
lame_cycleway = "(((bicycle=designated OR highway=cycleway) AND NOT #{cycleway}) AND NOT #{no_access} AND NOT area:highway)"
contraflow = "((cycleway=opposite_lane OR oneway:bicycle = no) AND NOT #{no_access})"
valid_bicycle_source_value = "(source:bicycle=sign OR source:bicycle=park_rules OR footway=sidewalk)" #footway=sidewalk is temporary as source:bicycle needs proper string for this status
def weird name, allowed
	returned = name
	allowed.each do |value|
		returned += " AND NOT #{name}=#{value}"
	end
	return "(#{returned})"
end
OK_surface_values = ["asphalt", "grass", "dirt", "compacted", "sett", "paved", "paving_stones", "gravel", "ground", "sand", "wood", "earth", "pebblestone", "concrete", "concrete:plates", "unpaved", "cobblestone"]
weird_main_surface = weird("surface", OK_surface_values)
used = ["motorway", "motorway_link", "trunk", "trunk_link", "primary", "primary_link", "secondary", "secondary_link", "tertiary", "tertiary_link", "pedestrian", "residential", "living_street", "unclassified", "service", "track", "footway", "cycleway", "path"]
discarded =["steps", "proposed", "construction", "bridleway", "platform", "bus_stop"]
weird_highway_value = weird("highway", used | discarded)
weird_cycleway_surface = weird("cycleway:surface", OK_surface_values)
puts "features"
puts "	lines"
puts "		high traffic cycleable road: #{high_traffic_road_accessible_to_bicycles}"
puts "		normal traffic cycleable road: #{normal_traffic_road_accessible_to_bicycles}"
puts "		low traffic cycleable road: #{low_traffic_road_accessible_to_bicycles}"
puts "		cycleable road: #{typical_road_accessible_to_bicycles}"
if debug
	puts "		weird highway value: #{weird_highway_value}"
	puts "		weird cycleway value: #{weird("cycleway", ["lane", "opposite_lane", "no", "opposite"])}"
	puts "		weird bicycle value: #{weird("bicycle", ["yes", "no", "designated", "dismount"])}"
	puts "		weird surface value: #{cycleable} AND (#{weird_main_surface} OR #{weird_cycleway_surface})"
	puts "		no_and_yes_bug: (#{cycleable} AND bicycle=no) OR (highway=cycleway AND bicycle AND NOT bicycle = designated AND NOT bicycle = dismount)"
	puts "		no_surface_info: (#{cycleway} OR #{lame_cycleway}) AND (#{no_surface_info_for_main_part} AND #{no_surface_info_for_lane})"
	puts "		no maxspeed info: (@isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, secondary_link) AND NOT maxspeed)"
	puts "		plus 50 maxspeed: (maxspeed > 50 AND NOT #{motorway})"
	puts "		missing segregate: ((bicycle=designated OR highway=cycleway) AND (foot=yes OR foot=designated OR bicycle=foot OR highway=footway) AND NOT segregated AND NOT area:highway)"
	puts "		weird segregate: #{weird("segregated", ["yes", "no"])}"
	puts "		footway should be path: (highway = footway AND bicycle = designated)"
	puts "		cycleway should be path: (highway = cycleway AND foot = designated)"
	puts "		bicycle oneway tag synch oneway bicycle: ((cycleway=opposite_lane OR cycleway=opposite) AND NOT oneway:bicycle=no)"
	puts "		bicycle oneway tag synch cycleway: ((NOT cycleway=opposite_lane AND NOT cycleway=opposite) AND oneway:bicycle=no AND oneway=yes)"
	puts "		railway: railway=rail" #to check coverage of landuse=railway
	puts ""
end
puts "		motorway: #{motorway}"
puts "		proper cycleway: #{cycleway} AND #{proper_surface} AND NOT #{terible_surface}"
puts "		proper cycleway with a bad surface: #{cycleway} AND NOT #{proper_surface} AND NOT #{terible_surface}"
puts "		proper cycleway with a terrible surface: #{cycleway} AND  #{terible_surface}"
puts "		lame cycleway with a good surface: #{lame_cycleway} AND #{proper_surface} AND NOT #{terible_surface}"
puts "		lame cycleway with a bad surface: #{lame_cycleway} AND NOT #{proper_surface}"
puts "		lame cycleway with a terrible surface: #{lame_cycleway} AND #{terible_surface}"
puts "		marked contraflow: #{contraflow} AND cycleway=opposite_lane"
puts "		unmarked contraflow: #{contraflow} AND NOT cycleway=opposite_lane"
puts "		oneway: (((oneway=yes AND NOT #{contraflow}) OR (oneway:bicycle=yes)) AND (#{cycleable} OR #{typical_road}))"
unexpected_allowed_cycling = "((bicycle=yes) AND NOT " + typical_road + " AND NOT #{no_access} AND NOT area=yes)"
bicycle_allowed = "(#{unexpected_allowed_cycling} OR (highway=pedestrian AND bicycle=yes))"
bicycle_allowed_not_in_park = "(#{bicycle_allowed} AND NOT source:bicycle=park_rules)"
bicycle_allowed_in_park = "(#{bicycle_allowed} AND source:bicycle=park_rules)"
puts "		bicycle_allowed_not_in_park: #{bicycle_allowed_not_in_park}"
puts "		bicycle_allowed_in_park: #{bicycle_allowed_in_park}"
puts "		bicycle allowed with a terrible surface: #{bicycle_allowed} AND #{terible_surface}"
unexpected_cycling_ban = "((bicycle=no AND #{typical_road}) OR (highway=pedestrian AND NOT bicycle=yes AND NOT bicycle = designated AND NOT cycleway=lane))"
puts "		unexpected cycling ban: #{unexpected_cycling_ban} AND NOT area = yes"
if heavy_debug
	puts "		expected explicit cycling ban: bicycle=no AND NOT #{unexpected_cycling_ban} AND NOT area = yes"
end
puts "	lines"
if debug
	puts "		bicycle unexpected status no source mentioned: ((#{unexpected_cycling_ban} AND NOT highway=pedestrian) OR #{unexpected_allowed_cycling}) AND NOT #{valid_bicycle_source_value}"
end
puts "	points"
bicycle_crossing_way = "((#{cycleway} OR #{lame_cycleway} OR #{unexpected_allowed_cycling}) AND NOT #{contraflow} AND NOT (cycleway=lane AND (highway=pedestrian OR #{typical_road})))" #it is an ugly hack as with Maperitive it is impossible to select nodes on way with condition A and on a separate way with condition B
puts "		OK_bicycle_crossing: way[#{bicycle_crossing_way}].node[highway=crossing AND (bicycle=yes)]"
puts "		not_OK_bicycle_crossing: way[#{bicycle_crossing_way}].node[highway=crossing AND bicycle=no]"
if debug
	puts "		not_defined_bicycle_crossing: way[#{bicycle_crossing_way}].node[highway=crossing AND NOT bicycle=yes AND NOT bicycle=no]"
	puts "		badly_defined_crossing: highway=crossing AND ((bicycle AND NOT bicycle=yes AND NOT bicycle=no) OR (foot AND NOT foot=yes AND NOT foot=no))"
end
puts "		advanced_stop_line: cycleway=advanced_stop_line"
puts "	points, lines, areas"
if debug
	puts "		fixme: (FIXME OR fixme) AND (fixme:type:bicycle=yes OR amenity=bicycle_parking OR bicycle OR highway=cycleway)"
end
puts "	points, areas"
bicycle_parking = "(amenity=bicycle_parking  AND NOT #{no_access})"
if debug
	puts "		bicycle_parking_no_capacity: #{bicycle_parking} AND NOT (capacity)"
	OK_bicycle_parking_values = ["wall_loops", "stands", "shed"]
	weird_bicycle_parking = weird("bicycle_parking", OK_bicycle_parking_values)
	puts "		bicycle_parking_no_type: #{bicycle_parking} AND (NOT bicycle_parking OR (#{weird_bicycle_parking}))"
	puts ""
end
if heavy_debug
	puts "		bicycle_parking_no_operator: #{bicycle_parking} AND NOT operator"
end
puts "		bicycle_parking: #{bicycle_parking}"
puts "		bicycle shop: shop=bicycle"
puts "		drinking_water: amenity=drinking_water"
puts "	areas"
puts "		water: natural=water OR waterway=riverbank OR waterway=dock OR landuse=reservoir"
puts "		trees: leisure=park OR landuse=forest OR landuse=orchard OR natural=wood OR leisure=garden"
puts "		blocked area: landuse=railway OR aeroway=aerodrome"
puts "	lines"
puts "		water-line: (waterway=stream OR waterway=river OR waterway=canal) AND NOT tunnel"
puts "properties"
puts "	map-background-color: white"
puts "	text-halo-width: 30%"
puts "	text-halo-opacity: 0.8"
puts ""
puts "rules"

puts get_bicycle_styles
