extends State

@onready var martial: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"

func enter() -> void:
	animation.play("idle")
	
func physics_update(delta: float) -> void:
	martial.velocity.y += GlobalScript.GRAVITY * delta
	martial.velocity.x = 0
	martial.move_and_slide()
	
	if martial.direction == 1:
		animation.flip_h = false
	elif martial.direction == -1:
		animation.flip_h = true
