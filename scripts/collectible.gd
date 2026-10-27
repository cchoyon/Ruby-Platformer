extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var item_type: String = "coin" # "coin" or "medic"
@export var is_dropped: bool = false # True = bounces out of enemy. False = floats in map.
@export var collect_sfx: AudioStream
	
const COIN_TEXTURE = preload("res://Assets/collactable items/coin.png")
const MEDIC_TEXTURE = preload("res://Assets/collactable items/medic.png")

enum Collect_State { DROPPED, IDLE, MAGNET, COLLECTING }
var current_state: = Collect_State.DROPPED

var bounce_factor = 0.5
var float_time = 0.0
var start_y = 0.0

var target_player: Node2D = null
var magnet_speed = 100.0
var max_magnet_speed = 850.0

func _ready() -> void:
	if item_type == "coin":
		sprite.texture = COIN_TEXTURE
	elif item_type == "medic":
		sprite.texture = MEDIC_TEXTURE
		
	start_y = global_position.y
	
	if is_dropped:
		current_state = Collect_State.DROPPED
		velocity = Vector2(randf_range(-180, 180), randf_range(-300, -450))
	else:
		current_state =Collect_State.IDLE
		collision_shape.disabled = true

func _physics_process(delta: float) -> void:
	match current_state:
		Collect_State.DROPPED:
			_handle_dropped_physics(delta)
			
		Collect_State.IDLE:
			if not is_dropped:
				float_time += delta
				global_position.y = start_y + (sin(float_time * 4.0) * 5.0)
				
		Collect_State.MAGNET:
			_handle_magnet_movement(delta)
			
		Collect_State.COLLECTING:
			pass

func _handle_dropped_physics(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GlobalScript.GRAVITY * delta
	else:
		if abs(velocity.y) > 40:
			velocity.y = -velocity.y * bounce_factor
			velocity.x = lerp(velocity.x, 0.0, 0.2)
		else:
			# Stop physics & set to IDLE once bouncing completely freezes
			velocity = Vector2.ZERO
			current_state = Collect_State.IDLE
			
			# Check if player was already inside pickup range while bouncing
			_check_for_nearby_player()

	move_and_slide()

func _handle_magnet_movement(delta: float) -> void:
	if not is_instance_valid(target_player):
		current_state = Collect_State.IDLE
		return
		
	# Accelerate snappily toward player's chest center
	magnet_speed = move_toward(magnet_speed, max_magnet_speed, 1400.0 * delta)
	var chest_position = target_player.global_position - Vector2(0, 16)
	
	global_position = global_position.move_toward(chest_position, magnet_speed * delta)
	
	# Trigger splash once it reaches player center
	if global_position.distance_to(chest_position) < 10.0:
		_play_collect_splash()

func _check_for_nearby_player() -> void:
	var pickup_area = get_node_or_null("PickupArea")
	if pickup_area:
		for body in pickup_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				_start_magnet(body)
				break

func _start_magnet(player: Node2D) -> void:
	if current_state != Collect_State.IDLE:
		return
		
	target_player = player
	current_state = Collect_State.MAGNET
	collision_shape.set_deferred("disabled", true)

func _play_collect_splash() -> void:
	current_state = Collect_State.COLLECTING
	
	SoundManager.play_sfx(collect_sfx, 0.15, -20.0)
	# Add item to inventory ONLY when it actually hits player center
	if item_type == "coin":
		GlobalScript.coins += 1
	elif item_type == "medic":
		GlobalScript.medics += 1

	# quick squish & fade pop
	var tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.6, 0.2), 0.07).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.09)
	
	await tween.finished
	queue_free()

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and current_state == Collect_State.IDLE:
		_start_magnet(body)
