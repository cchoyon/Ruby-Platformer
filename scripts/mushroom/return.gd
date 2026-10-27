extends State
@onready var mushroom: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var state_machine: mushroom_StateMachine = $".."

const Arrival_Tolerance = 5

func enter() -> void:
	animation.play("run")
	
func physics_update(delta: float) -> void:
	mushroom.velocity.y += GlobalScript.GRAVITY * delta
	
	var distance_to_spawn = mushroom.global_position.distance_to(mushroom.spawn_position)
	
	if (distance_to_spawn) <= Arrival_Tolerance:
		mushroom.velocity.x = 0
		state_machine.on_child_transition("idle")
		return
	
	mushroom.direction = sign(mushroom.spawn_position.x - mushroom.global_position.x)
	mushroom.velocity.x = mushroom.direction * mushroom.Speed
	
	mushroom.move_and_slide()
	
	if mushroom.direction == 1:
		animation.flip_h = false
	elif mushroom.direction == -1:
		animation.flip_h = true
		
