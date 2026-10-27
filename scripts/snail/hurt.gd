extends State

@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var snail = $"../.."
@onready var attacker_position = Vector2.ZERO

func enter() -> void:
	animation.play("hit")
	snail.velocity.x = 0
	
func physics_update(delta: float) -> void:
	
	snail.move_and_slide()

func _on_animation_animation_finished() -> void:
	if animation.animation == "hit":
		if snail.is_on_wall():
			snail.direction *=-1
			transitioned.emit("walk")
		else:
			transitioned.emit("walk")
			
