extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var state_machine = $".."
@onready var martial: CharacterBody2D = $"../.."
@onready var queue_timer = $queue_timer
@onready var collision_shape_2d: CollisionShape2D = $"../../hit_area/CollisionShape2D"
const COLLECTIBLE_SCENE = preload("res://scenes/collectible.tscn")
func _ready() -> void:
	if animation and not animation.animation_finished.is_connected(_on_animation_animation_finished):
			animation.animation_finished.connect(_on_animation_animation_finished)
func enter() -> void:
	collision_shape_2d.disabled = true
	animation.play("dead")
	martial.velocity.x = 0
	
func physics_update(delta: float) -> void:
	martial.velocity.y += GlobalScript.GRAVITY * delta
	martial.move_and_slide()
	

func _on_animation_animation_finished() -> void:
	if animation.animation == "dead":
		if martial.id !="":
			GameManager.regester_boss_death(martial.id)
		queue_timer.start()

func drop_items():
	# Drop Coins
	for i in randi_range(4,6):
		var coin = COLLECTIBLE_SCENE.instantiate()
		coin.item_type = "coin"
		coin.is_dropped = true # Turns on the bouncy physics!
		coin.global_position = martial.global_position
		get_tree().current_scene.add_child(coin)
		
	# Drop Medics
	for i in range(1):
		var medic = COLLECTIBLE_SCENE.instantiate()
		medic.item_type = "medic"
		medic.is_dropped = true
		medic.global_position = martial.global_position
		get_tree().current_scene.add_child(medic)
		
func _on_queue_timer_timeout() -> void:
	drop_items()
	martial.queue_free()
	
