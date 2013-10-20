def get_bicycle_styles
	returned = ""
	bugs = [
				["missing segregate", "blue"],
				["no_surface_info", "violet"],
				["weird segregate", "brown"],
				["weird cycleway value", "teal"],
				["weird bicycle value", "orange"],
				["weird tags", "black"],
				["weird surface value", "green"],
				["no_and_yes_bug", "purple"],
				["bicycle unexpected status no source mentioned", "gray"],
				["weird highway value", "lime"],
				["no oneway for bicycle instead of opposite_lane", "yellow"],
				["crossing_as_way_rather_than_node_bug", "red"],
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
	target: fixme
		define
			min-zoom : 1
			fill-color : pink
			shape-size : 6
			line-width : 0
		draw : shape
		draw : text

	target: not_defined_bicycle_crossing
		define
			min-zoom : 1
			fill-color : violet
			shape-size : 0:2; 16:3; 17:4; 18:5; 19:6; 20:7; 21:8
			line-width : 0
			//line-color : red
		draw : shape

	target: not_OK_bicycle_crossing
		define
			min-zoom : 1
			fill-color : red
			shape-size : 0:2; 16:3; 17:4; 18:5; 19:6; 20:7; 21:8
			line-width : 0
			//line-color : red
		draw : shape

	target: OK_bicycle_crossing
		define
			min-zoom : 14
			fill-color : green
			shape-size : 14:2; 16:3; 17:4; 18:5; 19:6; 20:7; 21:8
			line-width : 0
			//line-color : green
		draw : shape

	target: bicycle_parking_no_type
		define
			min-zoom : 1
			fill-color : red
			shape-size : 2
			line-width : 0
			shape: circle
		draw : shape

	target: bicycle_parking_no_capacity
		define
			min-zoom : 1
			fill-color : violet
			shape-size : 4
			line-width : 0
			shape: circle
		draw : shape

	target: bicycle shop
		define
			icon-image : icons/SJJB/png/shopping_bicycle.n.32.png
			min-zoom : 1
			max-zoom : 15
			icon-width : 10:8; 12:9; 13:10; 14:11; 15:12; 16:13; 17:14; 18:15; 19:16
		draw : icon
		define
			text : \"Sklep rowerowy \" name \" - \" opening_hours
			min-zoom : 15
			max-zoom : 25
			font-size : 13:9.5; 17:14
			font-weight : normal
			text-halo-color : #fffd8b
		draw : text

	target: bicycle_parking
		define
			fill-color : #6060ff
			min-zoom : 1
			shape-size : 10:3; 11:4; 12:5; 13:7; 14:8; 15:11; 16:13; 17:14; 18:16; 19:20
			line-width : 0
			line-color : white
			shape: square
		draw : shape

	target: drinking_water
		define
			icon-image : icons/SJJB/png/food_drinkingtap.n.32.png
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
			min-zoom : 14
			line-color : pink
			line-width : 2
			line-style : solid
		draw : line
		draw : text

	target : plus 50 maxspeed
		define
			min-zoom : 1
			line-color : black
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

	target : proper cycleway with a terrible surface
		define
			min-zoom : 9
			line-color : red
			line-width : 4
			line-style : solid
		draw : line
		draw : text

	target : lame cycleway with a terrible surface
		define
			min-zoom : 9
			line-color : red
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