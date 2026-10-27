extends State

@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var mushroom: CharacterBody2D = $"../.."
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $"../../hit_area/CollisionShape2D"
const COLLECTIBLE_SCENE = preload("res://scenes/collectible.tscn")
func enter() -> void:
	collision_shape_2d.disabled = true
	animation.play("dead")

func physics_update(delta: float) -> void:
	mushroom.velocity.x = 0
	mushroom.move_and_slide()
	
func drop_items():
	# Drop Coins
	for i in randi_range(2,4):
		var coin = COLLECTIBLE_SCENE.instantiate()
		coin.item_type = "coin"
		coin.is_dropped = true # Turns on the bouncy physics!
		coin.global_position = mushroom.global_position
		get_tree().current_scene.add_child(coin)
		
	# Drop Medics
	for i in range(1):
		var medic = COLLECTIBLE_SCENE.instantiate()
		medic.item_type = "medic"
		medic.is_dropped = true
		medic.global_position = mushroom.global_position
		get_tree().current_scene.add_child(medic)
		
func _on_animation_animation_finished() -> void:
	if animation.animation == "dead":
		timer.start()

func _on_timer_timeout() -> void:
	drop_items()
	mushroom.queue_free()
