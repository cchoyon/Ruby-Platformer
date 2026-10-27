class_name State
extends Node

# Signal to tell the StateMachine to switch states
signal transitioned(state_name: String)

# Equivalent to _ready() but called when entering this state
func enter() -> void:
	pass

# Equivalent to _exit_tree() but called when leaving this state
func exit() -> void:
	pass

# Equivalent to _process()
func update(_delta: float) -> void:
	pass

# Equivalent to _physics_process()
func physics_update(delta: float) -> void:
	pass
