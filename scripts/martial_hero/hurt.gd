extends State

@onready var martial: CharacterBody2D = $"../.."
@onready var state_machine = $".."
@onready var attack_area: Area2D = $"../../attack_area"
@onready var player_detection_area: Area2D = $"../../player_detection_area"
@onready var animation: AnimatedSprite2D = $"../../animation"


var Knockback_Strength_X = 320.0
var Knockback_Strength_Y = 150.0 # Bumped up slightly for a better visual pop
var last_attacker_position = Vector2.ZERO

func _ready() -> void:
	
	if animation and not animation.animation_finished.is_connected(_on_animation_animation_finished):
		animation.animation_finished.connect(_on_animation_animation_finished)
func enter() -> void:
	animation.play("hit")
	
	var hit_direction = sign(martial.global_position.x - last_attacker_position.x)
	if hit_direction == 0:
		hit_direction = -1 if animation.flip_h else 1
	
	martial.velocity.x = hit_direction * Knockback_Strength_X
	if martial.is_on_floor():
		martial.velocity.y = -Knockback_Strength_Y

	
func physics_update(delta: float) -> void:
	martial.velocity.y += GlobalScript.GRAVITY * delta

	var friction = 1200.0
	martial.velocity.x = move_toward(martial.velocity.x, 0, friction * delta)
	martial.move_and_slide()
	
	
func _on_animation_animation_finished() -> void:
	if animation.animation == "hit":
		martial.is_stunned = false
		var target = player_detection_area.get_overlapping_bodies()
		
		var attack_range  = attack_area.get_overlapping_bodies()
		for body in attack_range:
			if body.is_in_group("player"):
				var next_state = martial.get_next_attack()
				state_machine.on_child_transition(next_state)
				return		
		
		for body in target:
			if body.is_in_group("player"):
				state_machine.on_child_transition("run")
				return
		
		state_machine.on_child_transition("idle")	
