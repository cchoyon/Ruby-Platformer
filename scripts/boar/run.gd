extends State

@onready var player_detection_area: Area2D = $"../../player_detection_area"
@onready var boar: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var hit_area: Area2D = $"../../hit_area"
@onready var ground_check: RayCast2D = $right
@onready var state_machine: boar_StateMachine = $".."

const SPEED = 160.0
const LEDGE_CHECK_DISTANCE = 12.0  

var no_ground_dir: int = 0 
func enter() -> void:
	animation.play("run")
	no_ground_dir = 0

func physics_update(delta: float) -> void:
	boar.velocity.y += GlobalScript.GRAVITY * delta

	var player_found := false
	for body in player_detection_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			player_found = true
			if boar.is_on_floor():
				var wanted_dir = sign(body.global_position.x - boar.global_position.x)
				if wanted_dir != no_ground_dir:
					boar.direction = wanted_dir

	if not player_found:
		state_machine.transition_to("walk") 
		return

	if boar.is_on_floor():
		if is_ground_ahead(boar.direction):
			boar.velocity.x = boar.direction * SPEED
			no_ground_dir = 0
		else:
			boar.velocity.x = 0
			no_ground_dir = boar.direction
	else:
		boar.velocity.x = boar.direction * SPEED

	boar.move_and_slide()
	update_facing()

func is_ground_ahead(dir: int) -> bool:
	if dir == 0:
		return true
	ground_check.position.x = dir * LEDGE_CHECK_DISTANCE
	ground_check.force_raycast_update()
	return ground_check.is_colliding()

func update_facing() -> void:
	if boar.direction == 1:
		animation.flip_h = true
	elif boar.direction == -1:
		animation.flip_h = false

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(3, boar.global_position)
