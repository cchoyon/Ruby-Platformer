extends State

@onready var boar: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var ground_check: RayCast2D = $right

const SPEED = 80.0
const LEDGE_CHECK_DISTANCE = 12.0

func enter() -> void:
	animation.play("walk")

func physics_update(delta: float) -> void:
	boar.velocity.y += GlobalScript.GRAVITY * delta

	if boar.is_on_floor() and not is_ground_ahead(boar.direction):
		boar.direction *= -1  # flip once, decisively

	boar.velocity.x = boar.direction * SPEED
	boar.move_and_slide()
	update_facing()

func is_ground_ahead(dir: int) -> bool:
	ground_check.position.x = dir * LEDGE_CHECK_DISTANCE
	ground_check.force_raycast_update()
	return ground_check.is_colliding()

func update_facing() -> void:
	if boar.direction == 1:
		animation.flip_h = true
	elif boar.direction == -1:
		animation.flip_h = false
