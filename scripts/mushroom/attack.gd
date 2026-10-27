extends State
@onready var mushroom: CharacterBody2D = $"../.."
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var attack_area: Area2D = $"../../attack_area"
@export var swing_sfx: AudioStream
func enter() -> void:
	SoundManager.play_sfx(swing_sfx, 0.1, -30.0)
	animation.play("attack")
	mushroom.velocity.x = 0
	
func physics_update(delta: float) -> void:
	mushroom.velocity.y += GlobalScript.GRAVITY * delta
	mushroom.move_and_slide()
	
	var target = attack_area.get_overlapping_bodies()
	if animation.frame == 6:
		for body in target:
			if body.is_in_group("player"):
				body.take_damage(3,mushroom.global_position)
