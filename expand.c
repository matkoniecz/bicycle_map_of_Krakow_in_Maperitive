/*
use
gcc -E expand.c > test.txt
to expand macros. Run regexp "^" to add tabs, than replace part of Biking.mrules
this hack is hilarious ugly, but better than editing expanded form of this stuff
*/

#define __cycleable (highway=cycleway OR cycleway=lane OR bicycle = yes OR bicycle = designated OR cycleway=opposite_lane)
#define __typical_road @isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, tertiary, pedestrian, residential, living_street, unclassified)
#define __no_surface_for_lane ((cycleway=lane OR segregated = yes) AND NOT cycleway:right = surface* AND NOT cycleway:left = surface*) //not used, as lane may be the same as main
#define __paved_is_surface_for_lane ((cycleway=lane OR segregated = yes) AND (cycleway:right = "surface=paved" OR cycleway:left = "surface=paved"))
#define __separate_cycleway (highway=cycleway AND NOT segregated = no AND NOT foot = yes AND NOT foot = designated)
#define __segregated_cycleway ((highway=cycleway AND segregated = yes) OR (bicycle=designated AND segregated = yes) OR (cycleway = lane))
#define __proper_surface (surface = asphalt OR smoothness = excellent OR cycleway:right = "surface=asphalt" OR cycleway:left = "surface=asphalt")
#define __cycleway (__separate_cycleway OR __segregated_cycleway)

no_and_yes_bug : __cycleable AND bicycle=no
crossing_as_way_rather_than_node_bug : highway = crossing
no oneway for bicycle instead of opposite_lane : "oneway:bicycle" = "no" AND NOT cycleway=opposite_lane
no_surface_info : __cycleable AND (__paved_is_surface_for_lane OR (surface=paved OR (NOT (surface) AND NOT (tracktype)))) AND (NOT bicycle = yes OR NOT __typical_road)

proper cycleway : __cycleway AND __proper_surface
proper cycleway maybe with a bad surface : __cycleway
lame cycleway : ((bicycle=designated OR (highway=cycleway AND bicycle = yes)) AND NOT segregated = yes)
contraflow : cycleway=opposite_lane
bicycle allowed : (bicycle=yes) AND NOT __typical_road
dismount from bicycle : bicycle=dismount
unexpected cycling ban : bicycle=no AND __typical_road