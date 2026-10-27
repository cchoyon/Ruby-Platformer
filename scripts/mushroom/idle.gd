extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var mushroom: CharacterBody2D = $"../.."

func enter() -> void:
	animation.play("idle")
	mushroom.velocity.x = 0
	
func physics_update(delta: float) -> void:
	mushroom.velocity.y += GlobalScript.GRAVITY * delta
	mushroom.move_and_slide()
	
