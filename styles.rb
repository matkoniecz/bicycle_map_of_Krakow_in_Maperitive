def get_bicycle_styles
	returned = ""
	bugs = [
	#free colours: red
				["footway should be path", "black"],
				["cycleway should be path", "black"],
				["missing segregate", "blue"],
				["no_and_yes_bug", "purple"],
				["no_surface_info", "violet"],
				["weird segregate", "brown", " segregate"],
				["weird cycleway value", "teal", " cycleway"],
				["weird bicycle value", "orange", " bicycle"],
				["weird surface value", "yellow"],
				["bicycle unexpected status no source mentioned", "gray"],
				["weird highway value", "lime", " highway"],
				["bicycle oneway tag synch oneway bicycle", "#663300", "", "bicycle oneway tag synch +(oneway:bicycle)"], #bark brown
				["bicycle oneway tag synch cycleway", "#a61e00", "", "cycleway=opposite or cycleway=opposite is missing"], #bark brown + red
				#
			]
	bugs.each do |element|
		name = "name \" - #{element[0]}"
		if (element[3] != nil)
			name = "name \" - #{element[3]}"
		end
		if (element[2] != nil)
			name += "- \" #{element[2]}"
		else
			name += '"'
		end
		returned += "	target: #{element[0]}
		define
			min-zoom: 1
			line-color: #{element[1]}
			line-width: 10
			line-style: solid
		draw: line
		define
			min-zoom: 12
			text: #{name}
			font-size: 12
		draw: text

"
	end
return returned + "
	target: railway
		define
			min-zoom: 1
			line-color: #a1a1a1
			line-width: 1
		draw: line
	target: fixme
		define
			min-zoom: 1
			fill-color: pink
			shape-size: 6
			line-width: 0
		draw: shape
		draw: text

	target: not_defined_bicycle_crossing
		define
			min-zoom: 1
			fill-color: violet
			shape-size: 14:2; 16:3; 17:4; 18:5; 19:6; 20:7; 21:8
			line-width: 0
			//line-color: red
		draw: shape
	
	target: badly_defined_crossing
		define
			min-zoom: 1
			fill-color: black
			shape-size: 14:6; 16:10; 17:15; 18:20; 19:25
			line-width: 0
		draw: shape			

	target: not_OK_bicycle_crossing
		define
			min-zoom: 1
			fill-color: red
			shape-size: 14:2; 16:3; 17:4; 18:5; 19:6; 20:7; 21:8
			line-width: 0
			//line-color: red
		draw: shape

	target: OK_bicycle_crossing
		define
			min-zoom: 14
			fill-color: green
			shape-size: 14:2; 16:3; 17:4; 18:5; 19:6; 20:7; 21:8
			line-width: 0
			//line-color: green
		draw: shape

	target: bicycle_parking_no_operator
		define
			min-zoom: 1
			fill-color: yellow
			shape-size: 2
			line-width: 0
			line-color: yellow
			shape: circle
		draw: shape
	target: bicycle_parking_no_type
		define
			min-zoom: 1
			fill-color: red
			shape-size: 3
			line-width: 0
			shape: circle
		draw: shape

	target: bicycle_parking_no_capacity
		define
			min-zoom: 1
			fill-color: violet
			shape-size: 4
			line-width: 0
			shape: circle
		draw: shape

	target: bicycle shop
		define
			icon-image: icons/SJJB/png/shopping_bicycle.n.32.png
			min-zoom: 1
			max-zoom: 15
			icon-width: 10:8; 12:9; 13:10; 14:11; 15:12; 16:13; 17:14; 18:15; 19:16
		draw: icon
		define
			text: \"Sklep rowerowy \" name \" - \" opening_hours
			min-zoom: 15
			max-zoom: 25
			font-size: 13:9.5; 17:14
			font-weight: normal
			text-halo-color: #fffd8b
		draw: text

	target: bicycle_parking
		define
			fill-color: #6060ff
			min-zoom: 1
			shape-size: 10:3; 11:4; 12:5; 13:6; 14:7; 15:11; 16:13; 17:14; 18:16; 19:20
			line-width: 0
			line-color: white
			shape: square
		draw: shape
		define
			min-zoom: 15
			text: capacity
		draw: text

	target: drinking_water
		define
			icon-image: icons/SJJB/png/food_drinkingtap.n.32.png
			min-zoom: 1
			icon-width: 10:8; 12:9; 13:10; 14:11; 15:12; 16:13; 17:14; 18:15; 19:16
		draw: icon

	target: proper cycleway
		define
			min-zoom: 9
			line-color: green
			line-width: 4
			line-style: solid
		draw: line
		draw: text

	target: no maxspeed info
		define
			min-zoom: 14
			line-color: pink
			line-width: 2
			line-style: solid
		draw: line

	target: plus 50 maxspeed
		define
			min-zoom: 1
			line-color: black
			line-width: 2
			line-style: solid
		draw: line

	target: proper cycleway with a bad surface
		define
			min-zoom: 9
			line-color: #A0522D
			line-width: 4
			line-style: solid
		draw: line
		draw: text

	target: lame cycleway with a bad surface
		define
			min-zoom: 9
			line-color: #A0522D
			line-width: 2
			line-style: solid
		draw: line
		draw: text

	target: proper cycleway with a terrible surface
		define
			min-zoom: 9
			line-color: red
			line-width: 4
			line-style: solid
		draw: line
		draw: text

	target: lame cycleway with a terrible surface
		define
			min-zoom: 9
			line-color: red
			line-width: 2
			line-style: solid
		draw: line
		draw: text

	target: lame cycleway with a good surface
		define
			min-zoom: 9
			line-color: green
			line-width: 2
			line-style: solid
		draw: line
		draw: text

	target: marked contraflow
		define
			min-zoom: 9
			line-color: blue
			line-width: 7:1;12:2.5;17:3
			line-style: solid
			line-offset: 14:1;15:2;16:3;17:3
			line-offset-sides: left
		for: oneway=-1
			define
				line-offset-sides: right
		draw: line
		draw: text
		
	target: oneway
		define
			min-zoom: 15
			shape: custom
			shape-def: 0,10, 10,0, 0,-10, 10,0;Z
			shape-size: 7
			shape-spacing: 4
			line-width: 1
		draw: shape

	target: unmarked contraflow
		define
			min-zoom: 9
			line-color: blue
			line-width: 7:1;12:2.5;17:3
			line-style: dot
			line-offset: 14:0.5;15:1;16:2;17:3
			line-offset-sides: left
		for: oneway=-1
			define
				line-offset-sides: right
		draw: line
		draw: text
		define
			line-width: 1
			line-style: solid
		draw: line

	target: bicycle allowed
		define
			min-zoom: 9
			line-color: orange
			line-width: 2
			line-style: solid
			border-width: 0%
		draw: line
		draw: text

	target: dismount from bicycle
		define
			min-zoom: 9
			line-color: yellow
			line-width: 2
			line-style: solid
			border-width: 0%
		draw: line
		draw: text

	target: unexpected cycling ban
		define
			min-zoom: 9
			line-color: red
			line-width: 2
			line-style: dot
			border-width: 0%
		draw: line
		draw: text

	target: unexpected cycling ban area
		define
			fill-color: red
			line-color: red
			border-width: 0%
		draw: fill

	target: bicycle allowed area
		define
			fill-color: orange
			line-color: orange
			border-width: 0%
		draw: fill
"
end