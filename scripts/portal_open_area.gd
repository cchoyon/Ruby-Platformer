extends Area2D

@export var portal : Area2D
@export var portal_collisionShape : CollisionShape2D

var fade_tween: Tween

func _ready() -> void:
	portal.modulate.a = 0.0
	portal_collisionShape.set_deferred("disabled", true)
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "ruby":		
		portal_collisionShape.set_deferred("disabled", false)
		if fade_tween and fade_tween.is_running():
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(portal, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "ruby":		
		portal_collisionShape.set_deferred("disabled", true)
		if fade_tween and fade_tween.is_running():
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(portal, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
