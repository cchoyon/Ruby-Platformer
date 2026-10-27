extends State
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var snail: CharacterBody2D = $"../.."
const COLLECTIBLE_SCENE = preload("res://scenes/collectible.tscn")

func enter() -> void:
	animation.play("hide")
	snail.velocity.x = 0

func physics_update(delta: float) -> void:
	snail.move_and_slide()
	
func drop_items():
	for i in range(1):
		var medic = COLLECTIBLE_SCENE.instantiate()
		medic.item_type = "medic"
		medic.is_dropped = true
		medic.global_position = snail.global_position
		get_tree().current_scene.add_child(medic)


func _on_animation_animation_finished() -> void:
	if animation.animation == "hide":
		drop_items()
