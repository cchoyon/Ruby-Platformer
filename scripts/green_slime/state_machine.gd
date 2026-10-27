class_name slime_StateMachine
extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(new_state_name: String) -> void:
	var new_state = states.get(new_state_name.to_lower())
	if !new_state or new_state == current_state:
		return
		
	current_state.exit()
	new_state.enter()
	current_state = new_state
