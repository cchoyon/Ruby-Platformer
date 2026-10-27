extends State

@onready var boar: CharacterBody2D = $"../.."

const DEATH_SMOKE_SCENE = preload("res://scenes/death_smoke.tscn")
const COLLECTIBLE_SCENE = preload("res://scenes/collectible.tscn")

func drop_items():
	# Drop Coins
	for i in randi_range(1,5):
		var coin = COLLECTIBLE_SCENE.instantiate()
		coin.item_type = "coin"
		coin.is_dropped = true # Turns on the bouncy physics!
		coin.global_position = boar.global_position
		get_tree().current_scene.add_child(coin)
		
func enter() -> void:

	boar.velocity = Vector2.ZERO

	var smoke = DEATH_SMOKE_SCENE.instantiate()
	smoke.global_position = boar.global_position + Vector2(0, -8) # Slight upward offset
	get_tree().current_scene.add_child(smoke)

	drop_items()
	boar.queue_free()
	
func physics_update(_delta: float) -> void:
	pass
