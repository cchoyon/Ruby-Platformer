extends CanvasLayer

@onready var coin_text = $HBoxContainer/Label
@onready var medic_text = $HBoxContainer2/Label
@onready var health_bar: TextureProgressBar = $health_bar
var health_tween: Tween

func _ready() -> void:
	# Find player and connect to their signal automatically
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(update_health_ui)
		update_health_ui(player.current_health, player.max_health)
		
func _process(delta: float) -> void:
	# This keeps the text permanently updated with whatever is in your inventory
	coin_text.text = str(GlobalScript.coins)
	medic_text.text = str(GlobalScript.medics)
	
	var player = get_tree().get_first_node_in_group("player")
	if player and not player.health_changed.is_connected(update_health_ui):
		player.health_changed.connect(update_health_ui)
		update_health_ui(player.current_health, player.max_health)
		
func update_health_ui(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	
	# Kill previous tween if taking rapid damage
	if health_tween and health_tween.is_running():
		health_tween.kill()
		
	# Smoothly animate the health bar draining/filling over 0.2 seconds
	health_tween = create_tween()
	health_tween.tween_property(health_bar, "value", current_health, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
