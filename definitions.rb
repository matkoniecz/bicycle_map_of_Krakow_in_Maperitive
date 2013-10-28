def get_top 
return "
features
"
end

def get_bottom_before_bicycle_styles 
return "
	lines
		impassable: (railway=rail OR highway=motorway OR highway = motorway_link) AND NOT tunnel AND NOT bridge
	areas
		water: natural=water OR waterway=riverbank
	lines
		water-line: (waterway=stream OR waterway=river)
properties
	map-background-color	: white
	text-halo-width : 30%
	text-halo-opacity : 0.8

rules
"
end
def get_bottom_after_bicycle_styles 
return "
	target: cycleable road
		define
			min-zoom : 1
			line-width : 1
			line-color : #707070
		draw: line
	target: cycleable road
		define
			min-zoom : 16
		draw: text

	target: impassable
		define
			min-zoom : 1
			line-width : 2
			line-color : #404040
			line-style : solid
		draw: line

	target: water
		define
			fill-color: #b0b0ef
			line-width : 0
			line-color : #b0b0ef
		draw : fill
	target: water-line
		define
			line-width : 2
			line-color : #b0b0ef
		draw : line
"
end