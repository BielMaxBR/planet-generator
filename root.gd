extends Node2D

var offset = Vector2(71/2,53/2)
var correction_factor = 12/16.0
var gl = 0
# todos de 0 a 100
@export var noise_multiplier = 15
@export var min_radius := 15
@export var seed_radius = 20
# textura pré feita com noise2D, pode usar a linha de baixo caso não tenha
@onready var texture: NoiseTexture2D = load("res://text.tres")
#@onready var noise = texture.noise

@export var layers := [.25,.5,.93,1]

@onready var noise = FastNoiseLite.new()

func _ready() -> void:
	$CanvasLayer/NoiseSlider.value = noise_multiplier
	$CanvasLayer/RadiusSlider.value = min_radius
	$CanvasLayer/SeedsSlider.value = seed_radius
	make()
	#noise_multiplier = 0.001
var counter = 0
func _process(delta: float) -> void:
	gl += 1
	counter += delta
	
	#noise_multiplier += 0.003
	if counter > 0.05:
		make()
		counter = 0
func make():
	var mint = 0
	var maxt = 0
	$CanvasLayer/NoiseLabel.text = "Noise: %s" % str(noise_multiplier)
	$CanvasLayer/RadiusLabel.text = "Radius: %s" % str(min_radius)
	$CanvasLayer/SeedLabel.text =  "Seed: %s" % str(seed_radius)
	$TileMapLayer.clear()
	
	var actual_pos = Vector2($TileMapLayer.get_surrounding_cells(Vector2.ZERO)[2])
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
				actual_pos = Vector2($TileMapLayer.get_surrounding_cells(actual_pos)[i])
				#await get_tree().physics_frame
		actual_pos = Vector2($TileMapLayer.get_surrounding_cells(actual_pos)[4])
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
	$TileMapLayer.set_cell(pos + offset,0,Vector2i(tile,0))
	
#func _draw() -> void:
	#var i = 0
	#while (i < 2*PI):
		#var t = 10
		#
		#var pos = Vector2i((cos(i) * t) * min_radius, (sin(i) * t) * min_radius) + offset
		#draw_circle(pos,2,Color.YELLOW)
		#i += 0.01

func change():
	noise_multiplier = $CanvasLayer/NoiseSlider.value
	min_radius = $CanvasLayer/RadiusSlider.value
	seed_radius = $CanvasLayer/SeedsSlider.value
	make()

func _on_noise_slider_value_changed(value: float) -> void:
	change()

func _on_radius_slider_value_changed(value: float) -> void:
	change()

func _on_seeds_slider_value_changed(value: float) -> void:
	change()


func _on_zoom_slider_value_changed(value: float) -> void:
	if value < 0.001: value = 0.1
	var newzoom = Vector2.ONE * (value/2)
	$Camera2D.zoom = newzoom
	#$Camera2D.zoom = newzoom if newzoom.length() < 0.0001 else Vector2.ONE / 0.2
