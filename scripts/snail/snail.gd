extends CharacterBody2D

var direction = 1

var max_health = 4
var current_health = max_health

@onready var state_machine = $State_Machine
@export var hurt_sfx: AudioStream
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
func take_damage(amount):
	
	if current_health<=0:
		return
	
	SoundManager.play_sfx(hurt_sfx, 0.1, -30.0)	
	current_health -=amount
	
	if current_health<=0:
		state_machine.on_child_transition("Hide")
		return
	
	state_machine.on_child_transition("Hurt")
