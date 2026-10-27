extends State

@onready var priest: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"

func enter() -> void:
	animation.play("idle")
	
func physics_update(delta: float) -> void:
	priest.velocity.y += GlobalScript.GRAVITY * delta
	priest.velocity.x = 0
	priest.move_and_slide()
	
	if priest.direction == 1:
		animation.flip_h = false
	elif priest.direction == -1:
		animation.flip_h = true
