extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var priest: CharacterBody2D = $"../.."
@onready var player_detection_area: Area2D = $"../../player_detection_area"

func enter() -> void:
	animation.play("walk")
	
func physics_update(delta: float) -> void:
	priest.velocity.y+= GlobalScript.GRAVITY * delta
	var target = player_detection_area.get_overlapping_bodies()
	for body in target:
		if body.is_in_group("player"):
			priest.direction = sign(body.global_position.x - priest.global_position.x)
	
	priest.velocity.x = priest.direction * priest.Speed
	priest.move_and_slide()
	
	if priest.is_on_wall():
		priest.direction *=-1
		
	if priest.direction == 1:
		animation.flip_h = false
	elif priest.direction == -1:
		animation.flip_h = true
	
	
