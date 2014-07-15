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

def weird name, allowed
	returned = name
	allowed.each do |value|
		returned += " AND NOT #{name}=#{value}"
	end
	return "(#{returned})"
end

def is_one_of name, list
	values = ""
	list.each do |value|
		values += ", #{value}"
	end
	return "(@isOneOf(#{name}#{values}))"
end

mtb_route = "(mtb:scale AND NOT mtb:scale=0 AND NOT mtb:scale=0-)"
private_property = "(access=private OR access=no)" 
no_access = "(#{private_property} OR #{mtb_route})"
cycleable = "((highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane) AND NOT #{no_access}  AND NOT area:highway)"
motorway = "(highway=motorway OR highway=motorway_link OR highway=trunk OR highway=trunk_link)"
road_high_traffic_list = ["primary", "primary_link", "secondary", "secondary_link"]
road_normal_traffic_list = ["tertiary", "tertiary_link", "residential", "unclassified"]
road_low_traffic_list = ["service", "living_street", "track"]
unimportant_service = "(service=driveway OR service=parking_aisle)"
road_low_traffic = "(#{is_one_of("highway", road_low_traffic_list)} AND NOT #{unimportant_service} AND NOT #{no_access})"
roads = road_high_traffic_list | road_normal_traffic_list | road_low_traffic_list
typical_road = "(#{is_one_of("highway", roads)} AND NOT #{no_access})"
typical_road_accessible_to_bicycles = "(#{typical_road} AND NOT bicycle=no)"
high_traffic_road_accessible_to_bicycles = "(#{is_one_of("highway", road_high_traffic_list)} AND NOT bicycle=no AND NOT #{no_access})"
normal_traffic_road_accessible_to_bicycles = "((#{is_one_of("highway", road_normal_traffic_list)}) AND NOT bicycle=no AND NOT #{no_access})"
low_traffic_road_accessible_to_bicycles = "(#{is_one_of("highway", road_low_traffic_list)} AND NOT bicycle=no AND NOT #{no_access} AND NOT #{unimportant_service})"
minor_service_road_accessible_to_bicycles = "(#{is_one_of("highway", road_low_traffic_list)} AND NOT bicycle=no AND NOT #{no_access} AND #{unimportant_service})"
proper_surface = "(surface = asphalt OR smoothness = excellent OR smoothness = good OR smoothness = intermediate OR cycleway:surface=asphalt)"
terible_surface = "(smoothness = bad OR smoothness = very_bad OR smoothness = horrible OR smoothness = very_horrible OR smoothness = impassable OR surface = mud OR surface=cobblestone)"
cycleway_separated_from_road = "((highway=cycleway OR bicycle=designated) AND (segregated = yes OR NOT (foot=yes OR foot=designated)))"
cycleway = "((#{cycleway_separated_from_road} OR cycleway=lane) AND NOT #{no_access})"
no_surface_info_for_main_part = "(surface=paved OR surface=unpaved OR (NOT (surface) AND NOT (tracktype) AND NOT (smoothness)))"
no_surface_info_for_lane = "(cycleway:surface=paved OR cycleway:surface=unpaved OR NOT cycleway:surface)"
not_segregated_cycleway = "(((bicycle=designated OR highway=cycleway) AND NOT #{cycleway}) AND NOT #{no_access} AND NOT area:highway)"
valid_bicycle_source_value = "(source:bicycle=sign OR source:bicycle=park_rules OR source:bicycle=forest_rules OR source:bicycle=cemetery_rules OR footway=sidewalk OR footway=crossing)" #footway=sidewalk, footway=crossing hack is temporary as source:bicycle needs proper string for this status (but it probably will be checked anyway)
OK_surface_values = ["asphalt", "grass", "dirt", "compacted", "sett", "paved", "paving_stones", "gravel", "ground", "sand", "wood", "earth", "pebblestone", "concrete", "concrete:plates", "unpaved", "cobblestone", "mud"]
weird_main_surface = weird("surface", OK_surface_values)
used = ["motorway", "motorway_link", "trunk", "trunk_link", "primary", "primary_link", "secondary", "secondary_link", "tertiary", "tertiary_link", "pedestrian", "residential", "living_street", "unclassified", "service", "track", "footway", "cycleway", "path"]
discarded =["steps", "proposed", "construction", "bridleway", "platform", "bus_stop", "raceway"]
weird_highway_value = weird("highway", used | discarded)
weird_cycleway_surface = weird("cycleway:surface", OK_surface_values)
puts "features"
puts "	lines"
puts "		high traffic cycleable road: #{high_traffic_road_accessible_to_bicycles}"
puts "		normal traffic cycleable road: #{normal_traffic_road_accessible_to_bicycles}"
puts "		low traffic cycleable road: #{low_traffic_road_accessible_to_bicycles}"
puts "		minor service cycleable road: #{minor_service_road_accessible_to_bicycles}"
puts "		cycleable road: #{typical_road_accessible_to_bicycles}"
if debug
	puts "		missing designated: cycleway=lane AND NOT bicycle=designated"
	puts "		invalid designated: bicycle=designated AND NOT (cycleway=lane OR highway=path OR highway=cycleway OR highway=pedestrian OR highway=track)"
	puts "		weird cycleway value: #{weird("cycleway", ["lane", "opposite_lane", "no", "opposite", "crossing"])}"
	puts "		weird bicycle value: #{weird("bicycle", ["yes", "no", "designated", "permissive", "use_sidepath"])}"
	puts "		weird surface value: #{cycleable} AND (#{weird_main_surface} OR #{weird_cycleway_surface})"
	puts "		no_and_yes_bug: (#{cycleable} AND bicycle=no) OR (highway=cycleway AND bicycle AND NOT bicycle = designated AND NOT bicycle = dismount)"
	puts "		no_surface_info: (#{cycleway} OR #{not_segregated_cycleway}) AND (#{no_surface_info_for_main_part} AND #{no_surface_info_for_lane})"
	puts "		no maxspeed info: (@isOneOf(highway, primary, primary_link, secondary, secondary_link) AND NOT maxspeed)"
	puts "		plus 50 maxspeed: (maxspeed > 50 AND NOT #{motorway})"
	puts "		missing segregated: ((bicycle=designated OR highway=cycleway) AND (foot=yes OR foot=designated OR bicycle=foot OR highway=footway) AND NOT segregated AND NOT area:highway)"
	puts "		weird segregated: #{weird("segregated", ["yes", "no"])}"
	puts "		footway should be path: (highway = footway AND bicycle = designated)"
	puts "		cycleway should be path: (highway = cycleway AND foot = designated)"
	puts "		bicycle oneway tag synch oneway bicycle: ((cycleway=opposite_lane OR cycleway=opposite) AND NOT oneway:bicycle=no)"
	puts "		bicycle oneway tag synch cycleway: ((NOT cycleway=opposite_lane AND NOT cycleway=opposite) AND oneway:bicycle=no AND oneway=yes)"
	puts "		railway: railway=rail" #to check coverage of landuse=railway
	puts ""
end
if heavy_debug
	puts "		weird highway value: #{weird_highway_value}"
end
puts "		motorway: #{motorway}"
puts "		proper cycleway: #{cycleway} AND #{proper_surface} AND NOT #{terible_surface}"
puts "		proper cycleway with a bad surface: #{cycleway} AND NOT #{proper_surface} AND NOT #{terible_surface}"
puts "		proper cycleway with a terrible surface: #{cycleway} AND  #{terible_surface}"
puts "		not segregated cycleway with a good surface: #{not_segregated_cycleway} AND #{proper_surface} AND NOT #{terible_surface}"
puts "		not segregated cycleway with a bad surface: #{not_segregated_cycleway} AND NOT #{proper_surface}"
puts "		not segregated cycleway with a terrible surface: #{not_segregated_cycleway} AND #{terible_surface}"
unexpected_allowed_cycling = "((bicycle=yes OR bicycle=permissive) AND NOT #{no_access} AND NOT area=yes AND (highway=footway OR highway=path OR highway=pedestrian))"
unexpected_cycling_ban = "(((bicycle=no AND #{typical_road}) OR (highway=pedestrian AND NOT (bicycle=yes OR bicycle=permissive) AND NOT bicycle = designated AND NOT cycleway=lane)) AND NOT source:bicycle=cemetery_rules)"
puts "		marked contraflow: cycleway=opposite_lane AND NOT #{no_access}"
puts "		unmarked contraflow: cycleway=opposite AND NOT #{no_access} AND NOT #{unexpected_allowed_cycling}"
oneway = "(((oneway=yes AND NOT oneway:bicycle=no) OR (oneway:bicycle=yes)) AND (#{cycleable} OR #{typical_road}))"
unimportant_oneway = "(highway=motorway_link OR highway=trunk_link OR highway=primary_link OR highway=secondary_link OR highway=tertiary_link) OR dual_carriageway=yes OR dual_carriageway:bicycle=yes OR bicycle=use_sidepath"
separate_carriageway_rather_than_true_oneway = "(highway=motorway OR highway=primary OR highway=secondary OR #{unimportant_oneway})"
puts "		oneway: #{oneway}"
puts "		unexpected oneway: #{oneway} AND NOT #{separate_carriageway_rather_than_true_oneway} AND NOT junction=roundabout AND NOT highway=service AND (name OR highway=cycleway OR highway=path) AND NOT #{unexpected_cycling_ban}"
puts "		bicycle allowed not in park with not terible surface: #{unexpected_allowed_cycling} AND NOT source:bicycle=park_rules AND NOT #{terible_surface}"
puts "		bicycle allowed in park with not terible surface: #{unexpected_allowed_cycling} AND source:bicycle=park_rules AND NOT #{terible_surface}"
puts "		bicycle allowed not in a park with a terrible surface: #{unexpected_allowed_cycling} AND NOT source:bicycle=park_rules AND #{terible_surface}"
puts "		bicycle allowed in a park with a terrible surface: #{unexpected_allowed_cycling} AND source:bicycle=park_rules AND #{terible_surface}"
puts "		unexpected cycling ban: #{unexpected_cycling_ban} AND NOT area = yes"
if heavy_debug
	puts "		expected explicit cycling ban: bicycle=no AND NOT #{unexpected_cycling_ban} AND NOT area = yes"
end
puts "	lines"
if debug
	puts "		bicycle unexpected status no source mentioned: ((#{unexpected_cycling_ban} AND NOT highway=pedestrian) OR #{unexpected_allowed_cycling}) AND NOT #{valid_bicycle_source_value}"
end
puts "	points"
bicycle_crossing_way = "(highway=cycleway OR (highway=path AND bicycle=designated) OR #{unexpected_allowed_cycling})" #AND NOT (cycleway=lane AND (highway=pedestrian OR #{typical_road})))" #it is an ugly hack as with Maperitive it is impossible to select nodes on way with condition A and on a separate way with condition B
puts "		OK_bicycle_crossing: highway=crossing AND bicycle=yes AND NOT crossing=unmarked AND NOT segregated=no"
puts "		OK_bicycle_crossing_but_not_segregated: highway=crossing AND bicycle=yes AND NOT crossing=unmarked AND segregated=no"
puts "		not_OK_bicycle_crossing: way[#{bicycle_crossing_way}].node[highway=crossing AND bicycle=no]"
if debug
	crossing_requires_information_about_cycling_status = "(highway=crossing AND NOT bicycle=yes AND NOT bicycle=no AND NOT crossing=unmarked)"
	puts "		not_defined_bicycle_crossing: way[#{bicycle_crossing_way}].node[#{crossing_requires_information_about_cycling_status}]"
	puts "		badly_defined_crossing: highway=crossing AND ((bicycle AND NOT bicycle=yes AND NOT bicycle=no) OR (foot AND NOT foot=yes AND NOT foot=no) OR (bicycle AND crossing=unmarked))"
end
puts "		advanced_stop_line: cycleway=asl"
puts "	points, lines, areas"
if debug
	bicycle_tags = "(amenity=bicycle_parking OR bicycle OR highway=cycleway)"
	fixme = "(FIXME OR fixme)"
	if not heavy_debug
		fixme = "(#{fixme} AND fixme:type:requires_new_aerial_images!=yes)" 
	end
	puts "		fixme: #{fixme} AND (fixme:type:bicycle=yes OR #{bicycle_tags})"
	puts "		fixme: way[#{bicycle_tags}].node[#{fixme}]"
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
puts "		water-line: (waterway=river OR waterway=canal) AND NOT tunnel"
puts "		water-line-small: (waterway=stream OR waterway=ditch) AND NOT tunnel"
puts "properties"
puts "	map-background-color: white"
puts "	text-halo-width: 30%"
puts "	text-halo-opacity: 0.8"
puts ""
puts "rules"

puts get_bicycle_styles
