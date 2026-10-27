extends Node

var main_camera: Camera2D
var current_shake: float = 0.0

func _process(delta: float) -> void:
	# Smoothly decay camera shake
	if main_camera and current_shake > 0:
		main_camera.offset = Vector2(
			randf_range(-current_shake, current_shake),
			randf_range(-current_shake, current_shake)
		)
		# Uses unscaled delta so shake decays even during hit-stop
		current_shake = move_toward(current_shake, 0.0, delta * 40.0)
	elif main_camera:
		main_camera.offset = Vector2.ZERO


func shake_camera(intensity: float = 8.0) -> void:
	current_shake = intensity


func hit_stop(duration: float = 0.08, scale: float = 0.05) -> void:
	Engine.time_scale = scale

	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
