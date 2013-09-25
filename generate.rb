load "definitions.rb"
load "styles.rb"

#TODO handle cycleway=opposite (droga dwukierunkowa dla rowerzystów, dla reszty jednokierunkowa)

__cycleable = "(highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane)"
__typical_road = "@isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, tertiary, pedestrian, residential, living_street, unclassified)"
__separate_cycleway = "((highway=cycleway AND NOT segregated = no AND NOT foot = yes AND NOT foot = designated))"
__segregated_cycleway = "((highway=cycleway AND segregated = yes) OR (bicycle=designated AND segregated = yes) OR (cycleway = lane))"
__proper_surface = "(surface = asphalt OR smoothness = excellent OR smoothness = good OR smoothness = intermediate OR cycleway:right = \"surface=asphalt\" OR cycleway:left = \"surface=asphalt\" OR cycleway:surface=asphalt)"
__cycleway = "("+__separate_cycleway + " OR " + __segregated_cycleway + ")"
__paved_is_surface_for_lane = "(cycleway:right = \"surface=paved\" OR cycleway:left = \"surface=paved\" OR cycleway:surface=paved)"
__no_surface_info_for_main_part = "(surface=paved OR (NOT (surface) AND NOT (tracktype) AND NOT (smoothness)))"
__no_surface_info_for_lane = "((" +__paved_is_surface_for_lane + ") OR (NOT cycleway:left AND NOT cycleway:right AND NOT cycleway:surface))"
__lame_cycleway = "((bicycle=designated OR (highway=cycleway AND bicycle = yes)) AND NOT segregated = yes)"
__contraflow = "cycleway=opposite_lane"
__unexpected_allowed_cycling = "((bicycle=yes) AND NOT " + __typical_road + " AND NOT highway=service)"
__bicycle_dismount = "(bicycle=dismount)"

puts get_top
puts "		weird cycleway value : cycleway AND NOT cycleway=lane AND NOT cycleway=opposite_lane AND NOT cycleway=no AND NOT cycleway=opposite"
puts "		weird bicycle value : bicycle AND NOT bicycle=yes AND NOT bicycle=no AND NOT bicycle = designated AND NOT bicycle = dismount"
puts "		no_and_yes_bug : #{__cycleable} AND bicycle=no"
puts "		crossing_as_way_rather_than_node_bug : highway = crossing"
puts "		no oneway for bicycle instead of opposite_lane : \"oneway:bicycle\" = \"no\" AND NOT cycleway=opposite_lane"
puts "		no_surface_info : (#{__cycleway} OR #{__lame_cycleway} OR #{__contraflow} OR #{__unexpected_allowed_cycling} OR #{__bicycle_dismount}) AND (#{__no_surface_info_for_main_part} AND #{__no_surface_info_for_lane})"
puts ""
puts "		proper cycleway : #{__cycleway} AND #{__proper_surface}"
puts "		proper cycleway maybe with a bad surface : #{__cycleway}"
puts "		lame cycleway : #{__lame_cycleway}"
puts "		contraflow : #{__contraflow}"
puts "		bicycle allowed : #{__unexpected_allowed_cycling}"
puts "		dismount from bicycle : #{__bicycle_dismount}"
puts "		unexpected cycling ban : bicycle=no AND #{__typical_road}"
puts get_bottom_before_bicycle_styles 
puts get_bicycle_styles
puts get_bottom_after_bicycle_styles 
