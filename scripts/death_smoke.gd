extends CPUParticles2D

func _ready() -> void:
	emitting = true
	# Automatically destroy particle system after it finishes
	await get_tree().create_timer(lifetime).timeout
	queue_free()
