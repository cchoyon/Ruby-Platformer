extends State

@onready var martial: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var state_machine = $".."
@onready var timer: Timer = $Timer# Points to its OWN timer now!
@onready var attack_area: Area2D = $"../../attack_area"

func enter() -> void:
	animation.play("idle")
	timer.start() # Start resting immediately upon entering the state

func physics_update(delta: float) -> void:
	martial.velocity.y += GlobalScript.GRAVITY * delta
	martial.velocity.x = 0
	martial.move_and_slide()
	
	if martial.direction == 1:
		animation.flip_h = false
	elif martial.direction == -1:
		animation.flip_h = true

# Connected from the Cooldown node's own Timer child
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
		
	var next_state = martial.get_next_attack()
	state_machine.on_child_transition(next_state)

func exit() -> void:
	timer.stop()

		
