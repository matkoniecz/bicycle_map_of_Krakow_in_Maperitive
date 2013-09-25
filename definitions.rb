def get_top 
return "// Created by Igor Brejc
// Released under the Creative Commons Attribution-ShareAlike 3.0 License (http://creativecommons.org/licenses/by-sa/3.0/)
// Updates by Michael <quelbs_at_gmail.com>
// Icons used: Map icons CC-0 from SJJB Management (http://www.sjjb.co.uk/mapicons)
// Mutilated by Bulwersator (bulwersator@gmail.com) to display bicycle-related data.

features
	points
		place city : place=city
		place town : place=town
		place village : place=village
		place hamlet : place=hamlet
		place suburb : place=suburb

	points, areas
		railway station : railway=station
		park : leisure=park OR leisure=playground

	lines
		boundary country : boundary=administrative AND (admin_level=2 OR admin_level=4) AND NOT natural=coastline

		aeroway line runway : aeroway=runway
		aeroway line taxiway : aeroway=taxiway

		railway : railway=rail AND @isFalse(disused) AND NOT service=yard AND @isFalse(noexit)

		motorway : highway=motorway
		motorway link : highway=motorway_link
		major road : @isOneOf(highway, trunk, trunk_link, primary, primary_link, secondary, secondary_link, tertiary, tertiary_link)
		minor road : @isOneOf(highway, unclassified, residential, service, living_street, pedestrian) OR (highway=track AND (@isOneOf(tracktype, grade1, grade2, grade3) OR NOT tracktype))
		path : @isOneOf(highway, path, footway, steps) OR (highway=track AND @isOneOf(tracktype, grade4, grade5))

		water line : waterway=stream OR waterway=river
"
end

def get_bottom_before_bicycle_styles 
return "	areas
		water : natural=water OR natural=wetland OR waterway=riverbank OR waterway=stream OR landuse=reservoir OR landuse=basin
		aeroway area : aeroway
		industrial : landuse=industrial
		residential area : landuse=residential
		hospital : amenity=hospital
		sport : sport
		forest : landuse=forest OR natural=wood
		cemetery : landuse=cemetery


properties
	map-background-color	: #F2EFE9
	map-background-opacity	: 1
	map-sea-color : #99B3CC
	font-weight : bold
	font-family : Arial
	text-max-width : 7
	text-halo-width : 10%
	text-halo-opacity : 0.3
	text-align-horizontal : center
	text-align-vertical : center
	font-stretch : 0.9
	map.rendering.lflp.min-buffer-space : 5
	map.rendering.lflp.max-allowed-corner-angle : 40

rules
// icons
	target: park
		for : leisure=park
			define
				icon-image : icons/SJJB/png/landuse_coniferous.p.32.png
				min-zoom : 16
				icon-width : 16
		draw : icon
	target: railway station
		define
			icon-image : icons/SJJB/png/transport_train_station2.n.32.png
			min-zoom : 15
			icon-width : 16
		draw : icon
// texts
	target : $featuretype(point)
		define
			text-halo-width : 0%
		if : place*
			define
				//font-weight : bold

			if : *city
				define
					font-size : 8:14;11:17;14:18
					min-zoom : 6
					max-zoom : 16
			elseif : *town
				define
					font-size : 8:10;11:15;20:18
					min-zoom : 8
					max-zoom : 16
			elseif : *suburb
				define
					font-size : 13:10;20:20
					min-zoom : 11
					text-color : white black 50%
			elseif : *village
				define
					font-size : 12:10;20:20
					min-zoom : 11
			elseif : *hamlet
				define
					font-size : 14:8;20:16
					min-zoom : 14
		elseif : park
			define
				text-align-horizontal : near
				text-offset-horizontal : 7
				font-size : 14:8;20:10
				font-weight : normal
				min-zoom : 16
		else
			stop
		draw : text

// lines
"
end
def get_bottom_after_bicycle_styles 
return "
	target : boundary*
		define
			line-color : #818181
			line-width : 2
			border-style : solid
			border-color : #818181
			border-width : 110%
			border-opacity : 0.4
		draw : line

	target : aeroway line*
		define
			min-zoom : 9
			line-color : #9D9595
		if : aeroway line runway
			define
				line-width : 9:1;10:1;11:2;13:6;15:20
		else
			define
				line-width : 9:1;11:1;13:3;15:10
		draw : line

	target : railway
		define
			min-zoom : 13
			line-color : #a1a1a1
			line-width : 2
		draw : line
		define
			min-zoom : 13
			line-style : dashlong
			line-color : white
			line-width : 1
			border-style : solid
			border-color : #a1a1a1
			border-width : 25%
		draw : line
		define
			min-zoom : 6
			max-zoom : 13
			line-style : solid
			border-style : none
			line-color : #a1a1a1
			line-width : 1
		draw : line

	target : motorway
		define
			line-width : 7:1;13:3;15:10
			min-zoom : 7
			line-color : black
			border-style : solid
			border-color : #FFC345 black 20%
			border-width : 20%
		for : tunnel=yes
			define
				border-style : dot
		draw : line

	target : motorway link
		define
			line-width : 7:1;13:2;15:3
			min-zoom : 10
			line-color : gray
			border-style : solid
			border-color : #ffe068 black 20%
			border-width : 50%
		for : tunnel=yes
			define
				border-style : dot
		draw : line

	target : major road
		define
			min-zoom : 8
			line-color : #b3b3b3
			line-width : 10:1;13:2;14:3;15:4;18:12
			border-style : solid
			border-color : #b0b0b0
			border-width : 0

		for : highway=tertiary
			define
				min-zoom : 11
		for : tunnel=yes
			define
				border-style : dot
		draw : line

		define
			text:name
			min-zoom : 13
			font-size : 13:9.5
			font-weight : normal
			text-halo-color : #fffd8b
		draw : text

	target : minor road
		define
			min-zoom : 10.5
			max-zoom : 14.5
			border-style : none
			line-color : #D4CCB8
			line-width : 1
		draw : line
		define
			min-zoom : 13.1
			max-zoom : 20
			line-color : white
			line-width : 13:1.5;14:2.5;15:5;16:10
			border-style : solid
			border-color : #D4CCB8
			border-width : 1
			line-end-cap: round
		for : tunnel=yes
			define
				border-style : dot
		draw : line
		define
			min-zoom : 15
			max-zoom : 20
			font-size : 13:10
			font-stretch : 0.85
		draw : text
	target : *road
		for : oneway=yes OR oneway=true
			define
				min-zoom : 15
				shape : custom
				shape-def : 60,0,20,-40,20,-15,-60,-15,-60,15,20,15,20,40;Z
				shape-size : 12
				shape-aspect : 1
				shape-spacing : 10
				fill-color : #cccccc
				line-style : none
			for : oneway=-1
				define
					angle : 180
			draw : shape
	target : path
		define
			min-zoom : 14.5
			max-zoom : 20
			line-color : #F8F6EF
			border-style : solid
			border-width : 1
			border-color : #D4CCB8
			line-width : 14:1;15:1;15.5:4
		for : tunnel=yes
			define
				border-style : dot
		draw : line

	target : water line
		define
			min-zoom : 10
			line-color : #A5BFDD
			line-width : 14:1;16:5;20:10
		draw : line

// landuse

	target : $featuretype(area)
		define
			line-style : none
			line-width : 1
		if : water
			define
				fill-color : #A5BFDD
		elseif : aeroway area
			define
				fill-color : #d1d0cd
		elseif : industrial
			define
				fill-color : #d1d0cd
		elseif : residential area
			define
				fill-color : #EBE6DC
		elseif : hospital
			define
				fill-color : #e5c6c3
		elseif : park
			define
				fill-color : #b5d29c
		elseif : sport
			define
				fill-color : #d5e1dc
		elseif : cemetery
			define
				fill-color : #d1d0cd
		elseif : forest
			define
				min-zoom : 9
				fill-color : #CBD8C3
		else
			stop
		draw : fill

		define
			font-weight : normal
			text-halo-width : 20%
			text-halo-opacity : 0.9
		if : water
			define
				min-zoom : 12
				font-size : 12:10;20:20
		elseif : hospital
			define
				min-zoom : 13
				font-size : 10
				text-color : #e5c6c3 black 70%
				text-align-horizontal : near
				text-offset-horizontal : 100%
		else
			stop
		draw : text"
end