extends TileMapLayer

var correction_factor = 12/16.0
var gl = 0
# todos de 0 a 100
@export var offset = Vector2(35,26)
@export var noise_multiplier = 15
@export var min_radius := 15
@export var seed_radius = 20
# textura pré feita com noise2D, pode usar a linha de baixo caso não tenha
@onready var texture: NoiseTexture2D = load("res://sprites/text.tres")
@onready var noise = texture.noise

#@onready var noise = FastNoiseLite.new()
@export var layers := [.25,.5,.93,1]

func make():
	var mint = 0
	var maxt = 0
	clear()
	
	#var actual_pos = Vector2($TileMapLayer.get_surrounding_cells(Vector2.ZERO)[5])
	var actual_pos = Vector2.ZERO
	draw(actual_pos,layers[-1])
	var max_height = 1
	var has_tile = true
	while has_tile:
		has_tile = false
		for i in 6:
			for j in max_height:
				var ang = actual_pos.angle()
				var dist = Vector2(actual_pos.x/correction_factor, actual_pos.y).distance_to(Vector2.ZERO)
				#var dist = actual_pos.distance_squared_to(Vector2.ZERO)
				var xoff = (cos(ang)+1)*seed_radius + gl
				var yoff = (sin(ang)+1)*seed_radius
				var t = noise.get_noise_2d(xoff,yoff) + 1

				var actual_radius = t * noise_multiplier + min_radius
				if dist <= actual_radius:
					has_tile = true
					var tile: int = 0
					var factor = dist / actual_radius
					for l in layers:
						if factor >= l:
							tile += 1
						else:
							break
					
					draw(actual_pos,tile)
				#else:
					#print("no")
				actual_pos = Vector2(get_surrounding_cells(actual_pos)[i])
				#await get_tree().physics_frame
		actual_pos = Vector2(get_surrounding_cells(actual_pos)[4])
		max_height += 1
	# código antigo
	#var i = 0
	#while i < 2*PI:
		#var xoff = (cos(i)+1)*seed_radius
		#var yoff = (sin(i)+1)*seed_radius
		#var t = noise.get_noise_2d(xoff,yoff)
		#mint = min(t,mint)
		#maxt = max(t,maxt) 
		##var t = 1
		##min_radius = 0
		#var local_radius = min_radius
		#while local_radius > 0:
			#var pos = Vector2((cos(i) * t) * noise_multiplier * correction_factor + cos(i)*local_radius * correction_factor, (sin(i) * t) * noise_multiplier + sin(i)*local_radius)
			##var pos = Vector2i(i * 20,(sin(i) * t) * min_radius) + offset
			#draw(pos)
			#local_radius -= 1
		#
		#i += 0.01
	#print(mint," ", maxt, " "

func draw(pos, tile):
	#$TileMapLayer.set_cell($TileMapLayer.local_to_map(pos + offset),0,Vector2i(0,0))
	#offset = Vector2(22,40)
	set_cell(pos + offset,0,Vector2i(tile,0))
	
