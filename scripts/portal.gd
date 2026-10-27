extends Area2D

@export var target_marker_path: Marker2D
@export var portal_visual: Node2D 

var is_active: bool = true

func _on_body_entered(body: Node2D) -> void:	
	if body.name == "ruby" and is_active:
		is_active = false # Stop double triggers
		
		body.global_position = target_marker_path.global_position
		
		spawn_temporary_exit_portal()
		
		await get_tree().create_timer(1.0).timeout
		is_active = true

func spawn_temporary_exit_portal() -> void:
	if portal_visual and target_marker_path:
		var exit_portal = portal_visual.duplicate()
		
		exit_portal.set_script(null)
		
		
		if exit_portal is Area2D:
			exit_portal.monitoring = false
			exit_portal.monitorable = false

		exit_portal.global_position = target_marker_path.global_position
		exit_portal.modulate.a = 1.0 # Ensure it starts fully visible

		get_tree().current_scene.call_deferred("add_child", exit_portal)

		var exit_tween = create_tween()
		exit_tween.tween_property(exit_portal, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

		exit_tween.tween_callback(exit_portal.queue_free)
