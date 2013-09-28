load "definitions.rb"
load "styles.rb"

#TODO handle cycleway=opposite (droga dwukierunkowa dla rowerzystów, dla reszty jednokierunkowa)
#TODO find and kill "unpaved" as surface

__cycleable = "(highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane)"
__typical_road = "@isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, tertiary, pedestrian, residential, living_street, unclassified)"
__separate_cycleway = "((highway=cycleway AND NOT segregated = no AND NOT foot = yes AND NOT foot = designated))"
__segregated_cycleway = "((highway=cycleway AND segregated = yes) OR (bicycle=designated AND segregated = yes) OR (cycleway = lane))"
__proper_surface = "(surface = asphalt OR smoothness = excellent OR smoothness = good OR smoothness = intermediate OR cycleway:surface=asphalt)"
__cycleway = "("+__separate_cycleway + " OR " + __segregated_cycleway + ")"
__no_surface_info_for_main_part = "(surface=paved OR (NOT (surface) AND NOT (tracktype) AND NOT (smoothness)))"
__no_surface_info_for_lane = "(cycleway:surface=paved OR NOT cycleway:surface)"
__lame_cycleway = "((bicycle=designated OR highway=cycleway) AND NOT #{__cycleway})"
__contraflow = "(cycleway=opposite_lane)"
__unexpected_allowed_cycling = "((bicycle=yes) AND NOT " + __typical_road + " AND NOT highway=service)"
__bicycle_dismount = "(bicycle=dismount)"
def weird_surface name
	allowed = ["asphalt", "grass", "dirt", "compacted", "sett", "paved", "paving_stones", "gravel", "ground", "sand", "wood", "earth", "pebblestone", "concrete", "unpaved"]
	returned = name
	allowed.each do |value|
		returned += " AND NOT #{name}=#{value}"
	end
	return "(#{returned})"
end
__weird_main_surface = weird_surface("surface")
__weird_cycleway_surface = weird_surface("cycleway:surface")
__bicycle_parking = "(amenity=bicycle_parking)"

puts get_top
puts "	lines"
puts "		weird cycleway value : cycleway AND NOT cycleway=lane AND NOT cycleway=opposite_lane AND NOT cycleway=no AND NOT cycleway=opposite"
puts "		weird bicycle value : bicycle AND NOT bicycle=yes AND NOT bicycle=no AND NOT bicycle = designated AND NOT bicycle = dismount"
puts "		weird tags : cycleway:right OR cycleway:left"
puts "		weird surface value : #{__cycleable} AND (#{__weird_main_surface} OR #{__weird_cycleway_surface})"
puts "		no_and_yes_bug : #{__cycleable} AND bicycle=no"
puts "		crossing_as_way_rather_than_node_bug : highway = crossing"
puts "		no oneway for bicycle instead of opposite_lane : \"oneway:bicycle\" = \"no\" AND NOT cycleway=opposite_lane"
puts "		no_surface_info : (#{__cycleway} OR #{__lame_cycleway} OR #{__contraflow} OR #{__unexpected_allowed_cycling} OR #{__bicycle_dismount}) AND (#{__no_surface_info_for_main_part} AND #{__no_surface_info_for_lane})"
puts "		no maxspeed info : (@isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, tertiary, unclassified) AND NOT maxspeed)"
puts ""
puts "		proper cycleway : #{__cycleway} AND #{__proper_surface}"
puts "		proper cycleway with a bad surface : #{__cycleway} AND NOT #{__proper_surface}"
puts "		lame cycleway with a good surface: #{__lame_cycleway} AND #{__proper_surface}"
puts "		lame cycleway with a bad surface: #{__lame_cycleway} AND NOT #{__proper_surface}"
puts "		contraflow : #{__contraflow}"
puts "		bicycle allowed : #{__unexpected_allowed_cycling}"
puts "		dismount from bicycle : #{__bicycle_dismount}"
puts "		unexpected cycling ban : bicycle=no AND #{__typical_road}"
puts "	points, areas"
puts "		bicycle_parking_no_capacity : #{__bicycle_parking} AND NOT (capacity)"
puts "		bicycle_parking_no_type : #{__bicycle_parking} AND (NOT bicycle_parking OR (NOT (bicycle_parking=wall_loops) AND NOT (bicycle_parking=stands)))"
puts ""
puts "		bicycle_parking : #{__bicycle_parking}"
puts "		bicycle shop : shop=bicycle"
puts "		drinking_water : amenity=drinking_water"
puts get_bottom_before_bicycle_styles 
puts get_bicycle_styles
puts get_bottom_after_bicycle_styles 
