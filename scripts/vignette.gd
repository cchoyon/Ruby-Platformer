extends ColorRect

var tween: Tween

func flash_vignette() -> void:
	if tween and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	material.set("shader_parameter/opacity", 1.0)
	tween.tween_property(material, "shader_parameter/opacity", 0.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
