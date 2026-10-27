extends CharacterBody2D


const Speed = 180.0
var direction = 1
var is_stunned = false
var max_health = 8
var current_health = max_health

var attack_queue = []
var last_attack = ""
var last_pattern_id = -1

var id = "forest_priest"
@export var hurt_sfx: AudioStream
@onready var hit_area: Area2D = $hit_area

const Patterns := [
	["attack1", "attack1", "attack2"],
	["attack2", "attack2", "attack1"],
	["attack1", "attack2", "attack1"],
	["attack2", "attack1", "attack2"],
]
@onready var state_machine: priest_StateMachine = $State_Machine

func _ready() -> void:
	if GameManager.deadBoss.has(id):
		queue_free()
		return
		
func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if is_stunned:
		return
		
	if body.name == "ruby":
		state_machine.on_child_transition("walk")


func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if is_stunned:
		return
	if body.name == "ruby":
		state_machine.on_child_transition("idle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_stunned:
		return	
	if body.name == "ruby":
		var state = get_next_attack()
		state_machine.on_child_transition(state)


func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_stunned:
		return	
	
	if state_machine.current_state.name in ["Attack1","Attack2","Attack_Cooldown"]:
		return
	if body.name == "ruby":
		state_machine.on_child_transition("walk")

func get_next_attack()-> String:
	if attack_queue.is_empty():
		_refill_attack_queue()
	return attack_queue.pop_front()
	
func _refill_attack_queue() -> void: 
	var health_ratio = float(current_health) / float(max_health)
	if health_ratio >0.5:
		var choice = "attack1" if randi() %2 ==0 else "attack2"
		if choice == last_attack and attack_queue.size() >= 1:
			choice = "attack2" if choice == "attack1" else "attack2"
		attack_queue.append(choice)
		last_attack = choice
	else:
		var pool = Patterns.duplicate()
		
		if last_pattern_id != -1 and pool.size()	> 1:
			pool.remove_at(last_pattern_id)
		
		var picked_index = randi() % pool.size()
		var pattern = pool[picked_index]
		last_pattern_id = Patterns.find(pattern)
		
		attack_queue.append_array(pattern)
		last_attack = pattern[-1]
		
			
func take_damage(amount, attacker_position):
	if current_health <= 0:
		return
	SoundManager.play_sfx(hurt_sfx, 0.1, -30.0)
	current_health -= amount
	GameJuice.hit_stop(0.05, 0.08)  # Quick snappy hit stop
	GameJuice.shake_camera(2.0)
	
	is_stunned = true
	if current_health <= 0:
		state_machine.on_child_transition("dead")
		return

	$State_Machine/Hurt.last_attacker_position = attacker_position
	state_machine.on_child_transition("hurt")


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(2,global_position)	
