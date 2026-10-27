#green slime hurt state

extends State
@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var green_slime = $"../.."
@onready var attacker_position = Vector2.ZERO
const KnockBack_Force = 100.0

func enter() -> void:
	animation.play("hurt")
	green_slime.velocity.x = 0
	
func physics_update(delta: float) -> void:
	
	green_slime.move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "hurt":
		if green_slime.is_on_wall():
			transitioned.emit("idle")
			
		else:
			transitioned.emit("walk")
			
