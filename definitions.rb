def get_top 
return "
features
"
end

def get_bottom_before_bicycle_styles 
return "
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
			line-color : gray
		draw: line
		draw: text
"
end