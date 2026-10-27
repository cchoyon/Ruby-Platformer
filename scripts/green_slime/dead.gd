extends State

@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var green_slime: CharacterBody2D = $"../.."

const COLLECTIBLE_SCENE = preload("res://scenes/collectible.tscn")

func enter() -> void:
	animation.play("death")
	green_slime.velocity.x = 0
	
func drop_items():
	# Drop Coins
	for i in randi_range(1,4):
		var coin = COLLECTIBLE_SCENE.instantiate()
		coin.item_type = "coin"
		coin.is_dropped = true # Turns on the bouncy physics!
		coin.global_position = green_slime.global_position
		get_tree().current_scene.add_child(coin)
		
func physics_update(delta: float) -> void:
	green_slime.move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "death":
		drop_items()
		green_slime.queue_free()
