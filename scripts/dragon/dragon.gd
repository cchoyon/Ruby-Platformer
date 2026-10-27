extends CharacterBody2D

const fire_ball = preload("res://scenes/fire_ball.tscn")
@onready var animation: AnimatedSprite2D = $animation
@onready var marker_2d: Marker2D = $Marker2D

var player :CharacterBody2D=null


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "ruby":
		player = body
		animation.play("attack")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "ruby":
		player = null
		animation.play("idle")
		
func spawn_fireball() -> void:
	if player == null:
		return
	
	var fireball_instance = fire_ball.instantiate()
	fireball_instance.target = player
	fireball_instance.global_position = marker_2d.global_position
	
	get_parent().add_child(fireball_instance)


 

func _on_animation_animation_finished() -> void:
	if animation.animation == "attack":
		# Fire the projectile!
		spawn_fireball()
		
		# Decide what to do next based on whether the player escaped the detection zone
		if player != null:
			# Restart the attack animation to shoot another loop!
			animation.play("attack") 
		else:
			animation.play("idle")
