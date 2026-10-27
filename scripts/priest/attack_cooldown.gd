extends State

@onready var priest: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var state_machine: priest_StateMachine = $".."
@onready var timer: Timer = $Timer
@onready var attack_area: Area2D = $"../../attack_area"

func enter() -> void:
	animation.play("idle")
	timer.start() 

func physics_update(delta: float) -> void:
	priest.velocity.y += GlobalScript.GRAVITY * delta
	priest.velocity.x = 0
	priest.move_and_slide()
	
	if priest.direction == 1:
		animation.flip_h = false
	elif priest.direction == -1:
		animation.flip_h = true

func _on_timer_timeout() -> void:
	if state_machine.current_state != self:
		return
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
	state_machine.on_child_transition(next_state)

func exit() -> void:
	timer.stop()

		
