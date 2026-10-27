extends CharacterBody2D


var direction = -1
@onready var state_machine: boar_StateMachine = $State_Machine
@export var hurt_sfx: AudioStream
var max_health = 3
var current_health = max_health
var is_stunned =false
func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "ruby" and not is_stunned:
		state_machine.on_child_transition("Run")

func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "ruby" and not is_stunned:
		state_machine.on_child_transition("Walk")

func take_damage(amount, attacker_position):
	if current_health <= 0:
		return
	SoundManager.play_sfx(hurt_sfx, 0.1, -30.0)
	current_health -= amount
	GameJuice.hit_stop(0.05, 0.08)
	GameJuice.shake_camera(2.0)
	if current_health <= 0:
		state_machine.on_child_transition("dead")
		return

	$State_Machine/Hurt.last_attacker_position = attacker_position
	state_machine.on_child_transition("Hurt")
	
