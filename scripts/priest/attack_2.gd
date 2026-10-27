extends State
#attack2
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var priest: CharacterBody2D = $"../.."
@onready var state_machine: priest_StateMachine = $".."
@onready var attack_area: Area2D = $"../../attack_area"
@export var swing_sfx: AudioStream
const damage_frames = [2,7,12]
func _ready() -> void:
	if animation and not animation.animation_finished.is_connected(_on_animation_animation_finished):
		animation.animation_finished.connect(_on_animation_animation_finished)

func enter() -> void:
	SoundManager.play_sfx(swing_sfx, 0.1, 0.0)
	animation.play("attack2")


func physics_update(delta: float) -> void:
	# Stop moving while attacking, apply gravity
	priest.velocity.x = 0
	priest.velocity.y += GlobalScript.GRAVITY * delta
	priest.move_and_slide()

	# Face the player
	if priest.direction == 1:
		animation.flip_h = false
	elif priest.direction == -1:
		animation.flip_h = true

func _on_animation_animation_finished() -> void:
	#Safety check: is the character actually in the active state right now?
	if state_machine.current_state != self:
		return
	
	if animation.animation == "attack2":
		var target = attack_area.get_overlapping_bodies()
		var is_player_still_in_here = false
	
		for body in target:
			if body.is_in_group("player"):
				is_player_still_in_here = true
				break
	
		if not is_player_still_in_here:
			state_machine.on_child_transition("walk")
			return	
			
		var next_state = priest.get_next_attack()
		if next_state.to_lower() == "attack2":
			animation.frame = 0
			animation.play("attack2")
		else:
			state_machine.on_child_transition(next_state)


func _on_animation_frame_changed() -> void:
	if state_machine.current_state != self:
		return
	
	if animation.animation == "attack2" and animation.frame in damage_frames:
		var target = attack_area.get_overlapping_bodies()
		for body in target:
			if body.is_in_group("player"):
				body.take_damage(4,priest.global_position)		
