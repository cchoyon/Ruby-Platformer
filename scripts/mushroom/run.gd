extends State

@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var mushroom: CharacterBody2D = $"../.."
@onready var player_detect_area: Area2D = $"../../player_detect_area"

func enter() -> void:
	animation.play("run")
	
func physics_update(delta: float) -> void:
	mushroom.velocity.y += GlobalScript.GRAVITY * delta
	
	if mushroom.is_on_wall():
		mushroom.direction *=-1
		
	var target = player_detect_area.get_overlapping_bodies()
	
	for body in target:
		if body.is_in_group("player"):	
			mushroom.direction = sign(body.global_position.x - mushroom.global_position.x)
	
	mushroom.velocity.x = mushroom.direction * mushroom.Speed
	mushroom.move_and_slide()
	
	if mushroom.direction == 1:
		animation.flip_h = false
	elif mushroom.direction == -1:
		animation.flip_h = true
		
		
