def get_bicycle_styles
return "	target : weird cycleway value
		define
			min-zoom : 1
			line-color : #33ffff
			line-width : 20
			line-style : solid
		draw : line
		draw : text

	target : weird bicycle value
		define
			min-zoom : 1
			line-color : #666600
			line-width : 20
			line-style : solid
		draw : line
		draw : text

	target : no_and_yes_bug
		define
			min-zoom : 1
			line-color : purple
			line-width : 50
			line-style : solid
		draw : line
		draw : text

	target : crossing_as_way_rather_than_node_bug
		define
			min-zoom : 1
			line-color : red
			line-width : 50
			line-style : solid
		draw : line
		draw : text

	target : no oneway for bicycle instead of opposite_lane
		define
			min-zoom : 1
			line-color : yellow
			line-width : 10
			line-style : solid
		draw : line
		draw : text
	
	target : no_surface_info
		define
			min-zoom : 1
			line-color : violet
			line-width : 5
			line-style : solid
		draw : line
		draw : text

	target : proper cycleway
		define
			min-zoom : 9
			line-color : green
			line-width : 4
			line-style : solid
		draw : line
		draw : text

	target : proper cycleway maybe with a bad surface
		define
			min-zoom : 9
			line-color : #A0522D
			line-width : 4
			line-style : solid
		draw : line
		draw : text

	target : lame cycleway
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