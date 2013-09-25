/*
use
gcc -E expand.c > test.txt
to expand macros. Run regexp "^" to add tabs, than replace part of Biking.mrules
this hack is hilarious ugly, but better than editing expanded form of this stuff
*/
//TODO handle cycleway=opposite (droga dwukierunkowa dla rowerzystów, dla reszty jednokierunkowa)
#define __cycleable (highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane)
#define __typical_road @isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, tertiary, pedestrian, residential, living_street, unclassified)
#define __separate_cycleway ((highway=cycleway AND NOT segregated = no AND NOT foot = yes AND NOT foot = designated))
#define __segregated_cycleway ((highway=cycleway AND segregated = yes) OR (bicycle=designated AND segregated = yes) OR (cycleway = lane))
#define __proper_surface (surface = asphalt OR smoothness = excellent OR smoothness = good OR smoothness = intermediate OR cycleway:right = "surface=asphalt" OR cycleway:left = "surface=asphalt" OR cycleway:surface=asphalt)
#define __cycleway (__separate_cycleway OR __segregated_cycleway)
#define __paved_is_surface_for_lane (cycleway:right = "surface=paved" OR cycleway:left = "surface=paved" OR cycleway:surface=paved)
#define __no_surface_info_for_main_part (surface=paved OR (NOT (surface) AND NOT (tracktype) AND NOT (smoothness)))
#define __no_surface_info_for_lane ((__paved_is_surface_for_lane) OR (NOT cycleway:left AND NOT cycleway:right AND NOT cycleway:surface))

weird cycleway value : cycleway AND NOT cycleway=lane AND NOT cycleway=opposite_lane AND NOT cycleway=no AND NOT cycleway=opposite
weird bicycle value : bicycle AND NOT bicycle=yes AND NOT bicycle=no AND NOT bicycle = designated AND NOT bicycle = dismount
no_and_yes_bug : __cycleable AND bicycle=no
crossing_as_way_rather_than_node_bug : highway = crossing
no oneway for bicycle instead of opposite_lane : "oneway:bicycle" = "no" AND NOT cycleway=opposite_lane
no_surface_info : __cycleable AND NOT __typical_road AND (__no_surface_info_for_main_part AND __no_surface_info_for_lane)

proper cycleway : __cycleway AND __proper_surface
proper cycleway maybe with a bad surface : __cycleway
lame cycleway : ((bicycle=designated OR (highway=cycleway AND bicycle = yes)) AND NOT segregated = yes)
contraflow : cycleway=opposite_lane
bicycle allowed : (bicycle=yes) AND NOT __typical_road
dismount from bicycle : bicycle=dismount
unexpected cycling ban : bicycle=no AND __typical_road