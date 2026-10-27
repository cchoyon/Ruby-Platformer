extends CanvasLayer

@onready var animation_player = $fade_animation

func teleport_player(player: CharacterBody2D, target_marker: Marker2D):
	# 1. Start the Fade-In Screen Transition
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	# 2. Instantly move the player to the Marker2D position
	if is_instance_valid(player) and is_instance_valid(target_marker):
		
		player.set_position(target_marker.global_position)
		var camera = player.get_node_or_null("Camera2D")
		if camera:
			camera.reset_smoothing()		
	
	# 3. Start the Fade-Out Screen Transition
	animation_player.play("fade_out")
