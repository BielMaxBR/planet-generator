extends Node2D

# 11 16 3
func _ready() -> void:
	$CanvasLayer/NoiseSlider.value = $Map.noise_multiplier
	$CanvasLayer/RadiusSlider.value = $Map.min_radius
	$CanvasLayer/SeedsSlider.value = $Map.seed_radius
	$Map.make()

func change():
	$Map.noise_multiplier = $CanvasLayer/NoiseSlider.value
	$Map.min_radius = $CanvasLayer/RadiusSlider.value
	$Map.seed_radius = $CanvasLayer/SeedsSlider.value
	$CanvasLayer/NoiseLabel.text = "Noise: %s" % str($Map.noise_multiplier)
	$CanvasLayer/RadiusLabel.text = "Radius: %s" % str($Map.min_radius)
	$CanvasLayer/SeedLabel.text =  "Seed: %s" % str($Map.seed_radius)
	$Map.make()

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
