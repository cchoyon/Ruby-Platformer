extends State


@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var snail: CharacterBody2D = $"../.."

	
func physics_update(delta: float) -> void:
	
	var speed = 70.0
	snail.velocity.x = snail.direction * speed
	
	animation.play("walk")

	
	if snail.direction == 1:
		animation.flip_h = true
	elif snail.direction == -1:
		animation.flip_h = false
		
	snail.move_and_slide()
	if snail.is_on_wall():
		snail.direction *=-1
		snail.velocity.x = snail.direction * speed
