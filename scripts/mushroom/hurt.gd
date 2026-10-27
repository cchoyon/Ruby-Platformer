extends State

@onready var mushroom: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var state_machine: mushroom_StateMachine = $".."
@onready var player_detect_area: Area2D = $"../../player_detect_area"
@onready var attack_area: Area2D = $"../../attack_area"
@onready var timer: Timer = $Timer

var Knockback_Strength_X = 380.0
var Knockback_Strength_Y = 150.0 # Bumped up slightly for a better visual pop
var last_attacker_position = Vector2.ZERO
var stun_time = 0.0

func enter() -> void:
	animation.play("hit")
	
	var hit_direction = sign(mushroom.global_position.x - last_attacker_position.x)
	if hit_direction == 0:
		hit_direction = -1 if animation.flip_h else 1
	
	mushroom.velocity.x = hit_direction * Knockback_Strength_X
	if mushroom.is_on_floor():
		mushroom.velocity.y = -Knockback_Strength_Y

	
func physics_update(delta: float) -> void:
	mushroom.velocity.y += GlobalScript.GRAVITY * delta

	stun_time -= delta

	var friction = 1200.0
	mushroom.velocity.x = move_toward(mushroom.velocity.x, 0, friction * delta)
	mushroom.move_and_slide()
	
	
func _on_animation_animation_finished() -> void:
	if animation.animation == "hit":
		animation.play("idle")
		timer.start()

func _on_timer_timeout() -> void:
	mushroom.is_stunned = false
	var target = player_detect_area.get_overlapping_bodies()
	for body in target:
		if body.is_in_group("player"):
			state_machine.on_child_transition("run")
			return
			
	var target_1 = attack_area.get_overlapping_bodies()
	for body in target_1:
		if body.is_in_group("player"):
			state_machine.on_child_transition("attack")
			return
