extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var state_machine: priest_StateMachine = $".."
@onready var priest: CharacterBody2D = $"../.."
@onready var queue_timer: Timer = $queue_timer
@onready var collision_polygon_2d: CollisionPolygon2D = $"../../hit_area/CollisionPolygon2D"

const COLLECTIBLE_SCENE = preload("res://scenes/collectible.tscn")
func _ready() -> void:
	if animation and not animation.animation_finished.is_connected(_on_animation_animation_finished):
			animation.animation_finished.connect(_on_animation_animation_finished)
func enter() -> void:
	collision_polygon_2d.disabled = true
	animation.play("dead")
	priest.velocity.x = 0
	
func physics_update(delta: float) -> void:
	priest.velocity.y += GlobalScript.GRAVITY * delta
	priest.move_and_slide()
	
func drop_items():
	# Drop Coins
	for i in randi_range(3,5):
		var coin = COLLECTIBLE_SCENE.instantiate()
		coin.item_type = "coin"
		coin.is_dropped = true # Turns on the bouncy physics!
		coin.global_position = priest.global_position
		get_tree().current_scene.add_child(coin)
		
	# Drop Medics
	for i in range(1):
		var medic = COLLECTIBLE_SCENE.instantiate()
		medic.item_type = "medic"
		medic.is_dropped = true
		medic.global_position = priest.global_position
		get_tree().current_scene.add_child(medic)
		
func _on_animation_animation_finished() -> void:
	if animation.animation == "dead":
		if priest.id !="":
			GameManager.regester_boss_death(priest.id)
		
		queue_timer.start()

func _on_queue_timer_timeout() -> void:
	drop_items()
	priest.queue_free()
