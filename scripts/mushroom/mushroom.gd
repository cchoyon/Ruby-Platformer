extends CharacterBody2D

var direction = -1
const Speed = 200
var spawn_position :Vector2
var max_health = 5
var current_health = max_health
var is_stunned = false
@onready var state_machine: mushroom_StateMachine = $State_Machine
@onready var animation: AnimatedSprite2D = $animation
@onready var hit_area: Area2D = $hit_area
@export var hurt_sfx: AudioStream
func _ready() -> void:
	spawn_position = global_position
	
func _on_player_detect_area_body_entered(body: Node2D) -> void:
	if is_stunned:
		return
	if body.name == "ruby":
		state_machine.on_child_transition("run")

func _on_player_detect_area_body_exited(body: Node2D) -> void:
	if is_stunned:
		return
	if body.name == "ruby":
		state_machine.on_child_transition("idle")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_stunned:
		return
	if body.name == "ruby":
		state_machine.on_child_transition("attack")

func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_stunned:
		return
	if body.name == "ruby":
		state_machine.on_child_transition("run")
	
func take_damage(amount, attacker_position):
	if current_health <= 0:
		return
	
	SoundManager.play_sfx(hurt_sfx, 0.1, -30.0)
	current_health -= amount
	is_stunned = true
	if current_health <= 0:
		state_machine.on_child_transition("dead")
		return

	$State_Machine/Hurt.last_attacker_position = attacker_position
	state_machine.on_child_transition("hurt")


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.name == "ruby":
		body.take_damage(2,global_position)
