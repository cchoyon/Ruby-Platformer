extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var martial: CharacterBody2D = $"../.."
@onready var player_detection_area: Area2D =$"../../player_detection_area"
@onready var attack_area: Area2D = $"../../attack_area"

func enter() -> void:
	animation.play("run")
	
func physics_update(delta: float) -> void:
	martial.velocity.y+= GlobalScript.GRAVITY * delta
	var target = player_detection_area.get_overlapping_bodies()
	for body in target:
		if body.is_in_group("player"):
			martial.direction = sign(body.global_position.x - martial.global_position.x)
	
	martial.velocity.x = martial.direction * martial.Speed
	martial.move_and_slide()
	
	if martial.is_on_wall():
		print("is on wall")
		martial.direction *=-1
		
	if martial.direction == 1:
		animation.flip_h = false
		attack_area.scale.x = 1
	elif martial.direction == -1:
		animation.flip_h = true
		attack_area.scale.x = -1
	
	
