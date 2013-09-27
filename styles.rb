def get_bicycle_styles
	returned = ""
	bugs = [
				["weird cycleway value", "teal"],
				["weird bicycle value", "orange"],
				["weird tags", "black"],
				["weird surface value", "green"],
				["no_and_yes_bug", "purple"],
				["crossing_as_way_rather_than_node_bug", "red"],
				["no oneway for bicycle instead of opposite_lane", "yellow"],
				["no_surface_info", "violet"],
			]
	bugs.each do |element|
		returned += "	target : #{element[0]}
		define
			min-zoom : 1
			line-color : #{element[1]}
			line-width : 10
			line-style : solid
		draw : line
		draw : text

"
	end
return returned + "
	target: bicycle_parking_no_type
		define
			min-zoom : 1
			fill-color : red
			shape-size : 3
			line-width : 0
		draw : shape

	target: bicycle_parking_no_capacity
		define
			min-zoom : 1
			fill-color : violet
			shape-size : 5
			line-width : 0
		draw : shape

	target: bicycle_parking
		define
			icon-image : icons/SJJB/png/transport_parking_bicycle.n.32.png
			min-zoom : 1
			icon-width : 10:8; 12:9; 13:10; 14:11; 15:12; 16:13; 17:14; 18:15; 19:16
		draw : icon

	target: bicycle shop
		define
			icon-image : icons/SJJB/png/shopping_bicycle.n.32.png
			min-zoom : 1
			icon-width : 10:8; 12:9; 13:10; 14:11; 15:12; 16:13; 17:14; 18:15; 19:16
		draw : icon

	target : proper cycleway
		define
			min-zoom : 9
			line-color : green
			line-width : 4
			line-style : solid
		draw : line
		draw : text

	target : no maxspeed info
		define
			min-zoom : 1
			line-color : purple
			line-width : 2
			line-style : solid
		draw : line
		draw : text

	target : proper cycleway with a bad surface
		define
			min-zoom : 9
			line-color : #A0522D
			line-width : 4
			line-style : solid
		draw : line
		draw : text

	target : lame cycleway with a bad surface
		define
			min-zoom : 9
			line-color : #A0522D
			line-width : 2
			line-style : solid
		draw : line
		draw : text

	target : lame cycleway with a good surface
		define
			min-zoom : 9
			line-color : green
			line-width : 2
			line-style : solid
		draw : line
		draw : text

	target : contraflow
		define
			min-zoom : 9
			line-color : blue
			line-width : 7:1;12:2.5;17:3
			line-style : solid
			line-offset : 14:0.5;15:1;16:2;17:3
			line-offset-sides : left
		for : oneway=-1
			define
				line-offset-sides : right
		draw : line
		draw : text

	target : bicycle allowed
		define
			min-zoom : 9
			line-color : orange
			line-width : 2
			line-style : solid
			border-width : 0%
		draw : line
		draw : text

	target : dismount from bicycle
		define
			min-zoom : 9
			line-color : yellow
			line-width : 2
			line-style : solid
			border-width : 0%
		draw : line
		draw : text

	target : unexpected cycling ban
		define
			min-zoom : 9
			line-color : red
			line-width : 4
			line-style : dot
			border-width : 0%
		draw : line
		draw : text
"
end