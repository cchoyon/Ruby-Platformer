extends State
#attack1
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var martial: CharacterBody2D = $"../.."
@onready var state_machine = $".."
@onready var attack_area: Area2D =$"../../attack_area"
@export var swing_sfx: AudioStream
func enter() -> void:
	SoundManager.play_sfx(swing_sfx, 0.1, -30.0)
	animation.play("attack1")

func physics_update(delta: float) -> void:
	martial.velocity.x = 0
	martial.velocity.y += GlobalScript.GRAVITY * delta
	martial.move_and_slide()

	if martial.direction == 1:
		animation.flip_h = false
		attack_area.scale.x = 1
	elif martial.direction == -1:
		animation.flip_h = true
		attack_area.scale.x = -1



func _on_animation_frame_changed() -> void:
	if state_machine == null:
		print("state machine is null")
		return
		
	if state_machine.current_state != self:
		return
		
	if animation.animation == "attack1" and animation.frame == 4:
		
		var target = attack_area.get_overlapping_bodies()
		for body in target:
			if body.is_in_group("player"):
				body.take_damage(4,martial.global_position)		


func _on_animation_animation_finished() -> void:
	if state_machine.current_state != self:
		return
	
	if animation.animation == "attack1":
		var target = attack_area.get_overlapping_bodies()
		var is_player_still_in_here = false
		
		for body in target:
			if body.is_in_group("player"):
				is_player_still_in_here = true
				
		
		if not is_player_still_in_here:
			state_machine.on_child_transition("run")
			return	
			
		var next_state = martial.get_next_attack()
		if next_state.to_lower() == "attack1":
			animation.frame = 0
			animation.play("attack1")
		else:
			state_machine.on_child_transition(next_state)
