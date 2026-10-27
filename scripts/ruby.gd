extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine
var max_health =67
var current_health = 67
var safe_position_timer = 0.0
var enemies_nearby = 0
var time_since_hit = 10.0

var pressed_pause = false
var has_control = false
const collectable_items = preload("res://scenes/collectible.tscn")
@onready var death_ui: CanvasLayer = $DeathUI
@onready var main_menu: CanvasLayer = $MainMenu
@onready var camera_2d: Camera2D = $Camera2D

@export var level_bgm: AudioStream
@export var hurt_sfx: AudioStream


signal health_changed(current_health, max_health)

func _ready() -> void:
	GameJuice.main_camera = $Camera2D
	current_health = GameManager.current_health
	health_changed.emit(current_health, max_health)
	if GameManager.game_started == false: 
		main_menu.show()
		has_control = false
	else:
		main_menu.hide()
		has_control = true
	
	if GameManager.last_safe_position !=Vector2.ZERO:
		global_position = GameManager.last_safe_position
	
	if level_bgm:
		SoundManager.play_bgm(level_bgm)

func _physics_process(delta: float) -> void:
	if not has_control:
		return
		
	time_since_hit += delta
	
	if is_on_floor() and enemies_nearby <=0 and time_since_hit >5.0:
		safe_position_timer += delta
		if safe_position_timer >= 3.0:
			GameManager.last_safe_position = global_position
	
	else:
		safe_position_timer = 0.0
		
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("peds"): body.take_damage(2)

func take_damage(amount,attacker_position):
	if current_health <=0:
		return
	SoundManager.play_sfx(hurt_sfx, 0.1, -30.0)
	current_health -= amount
	
	GameJuice.hit_stop(0.12, 0.02)
	GameJuice.shake_camera(2.0)
	var vignette = get_tree().get_first_node_in_group("vignette")
	if vignette:
		vignette.flash_vignette()
		
	time_since_hit = 0.0
	if current_health <=0:
		current_health = 0
		GameManager.current_health = 0
		has_control = false
		death_ui.show()
		GlobalScript.coins = 0
		GlobalScript.medics = 0
		return
		
	GameManager.current_health = current_health
	health_changed.emit(current_health, max_health)
	$StateMachine/Hurt.last_attacker_position = attacker_position
	
	state_machine.on_child_transition("Hurt")

func _on_danger_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemies_nearby +=1


func _on_danger_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemies_nearby -=1
	

func _on_play_pressed() -> void:
	GameManager.game_started = true
	main_menu.hide()
	has_control = true


func _on_exit_pressed() -> void:
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and pressed_pause == false:
		pressed_pause = true
		death_ui.show()
		has_control = false
	
	elif event.is_action_pressed("ui_cancel") and pressed_pause:
		pressed_pause = false
		death_ui.hide()
		has_control = true
	
	if event.is_action_pressed("E"):
		if GlobalScript.medics > 0 and current_health < max_health:
			GlobalScript.medics -= 1
			current_health = min(current_health + 20, max_health)
			
			GameManager.current_health = current_health
			health_changed.emit(current_health, max_health)

			if current_health > max_health:
				current_health = max_health
		

func restart() -> void:
	get_tree().reload_current_scene()

func _on_restart_pressed() -> void:
	GlobalScript.coins = 0
	GlobalScript.medics = 0
	GameManager.current_health = GameManager.respawn_health
	restart()
