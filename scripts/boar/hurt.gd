extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var boar: CharacterBody2D = $"../.."
@onready var player_detection_area: Area2D = $"../../player_detection_area"
@onready var state_machine: boar_StateMachine = $".."

const Knockback_Strength_X = 500.0
const Knockback_Strength_Y = 100.0
var last_attacker_position = Vector2.ZERO
var stun_time = 0.0

func enter() -> void:
	boar.is_stunned = true
	animation.play("hit")
	var hit_direction = sign(boar.global_position.x - last_attacker_position.x)
	if hit_direction == 0:
		hit_direction = -1 if animation.flip_h else 1
	boar.velocity.x = hit_direction * Knockback_Strength_X
	if boar.is_on_floor():
		boar.velocity.y = -Knockback_Strength_Y
	stun_time = 0.3

func physics_update(delta: float) -> void:
	boar.velocity.y += GlobalScript.GRAVITY * delta   # was missing — boar wasn't coming back down
	boar.velocity.x = move_toward(boar.velocity.x, 0, 1200.0 * delta)
	boar.move_and_slide()

	stun_time -= delta

	if stun_time < 0.0 and boar.is_on_floor():
		boar.is_stunned = false
		if is_player_in_range():
			state_machine.on_child_transition("Run")
		else:
			state_machine.on_child_transition("Walk")

func is_player_in_range() -> bool:
	for body in player_detection_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func exit() -> void:
	boar.is_stunned = false 
