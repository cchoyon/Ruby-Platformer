extends State

@onready var priest: CharacterBody2D = $"../.."
@onready var state_machine: priest_StateMachine = $".."
@onready var attack_area: Area2D = $"../../attack_area"
@onready var player_detection_area: Area2D = $"../../player_detection_area"
@onready var animation: AnimatedSprite2D = $"../../animation"


var Knockback_Strength_X = 320.0
var Knockback_Strength_Y = 150.0 
var last_attacker_position = Vector2.ZERO
var stun_time = 0.0

func enter() -> void:
	animation.play("hit")
	
	var hit_direction = sign(priest.global_position.x - last_attacker_position.x)
	if hit_direction == 0:
		hit_direction = -1 if animation.flip_h else 1
	
	priest.velocity.x = hit_direction * Knockback_Strength_X
	if priest.is_on_floor():
		priest.velocity.y = -Knockback_Strength_Y

	
func physics_update(delta: float) -> void:
	priest.velocity.y += GlobalScript.GRAVITY * delta

	stun_time -= delta

	var friction = 1200.0
	priest.velocity.x = move_toward(priest.velocity.x, 0, friction * delta)
	priest.move_and_slide()
	
	
func _on_animation_animation_finished() -> void:
	if animation.animation == "hit":
		priest.is_stunned = false
		var target = player_detection_area.get_overlapping_bodies()
		for body in target:
			if body.is_in_group("player"):
				state_machine.on_child_transition("walk")
				return
				
		var target_1 = attack_area.get_overlapping_bodies()
		for body in target_1:
			if body.is_in_group("player"):
				var next_state = priest.get_next_attack()
				state_machine.on_child_transition(next_state)
				return
