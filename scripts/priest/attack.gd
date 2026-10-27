extends State
#attack1
@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var priest: CharacterBody2D = $"../.."
@onready var state_machine: priest_StateMachine = $".."
@onready var attack_area: Area2D = $"../../attack_area"
@export var swing_sfx: AudioStream
func enter() -> void:
	SoundManager.play_sfx(swing_sfx, 0.1, -30.0)
	animation.play("attack1")

func physics_update(delta: float) -> void:
	priest.velocity.x = 0
	priest.velocity.y += GlobalScript.GRAVITY * delta
	priest.move_and_slide()

	if priest.direction == 1:
		animation.flip_h = false
	elif priest.direction == -1:
		animation.flip_h = true

func _on_animation_animation_finished() -> void:
	if state_machine.current_state != self:
		return
		
	if animation.animation == "attack1":
		state_machine.on_child_transition("Attack_Cooldown")


func _on_animation_frame_changed() -> void:
	if state_machine == null:
		return

	if state_machine.current_state != self:
		return
		
	if animation.animation == "attack1" and animation.frame == 2:
		
		var target = attack_area.get_overlapping_bodies()
		for body in target:
			if body.is_in_group("player"):
				body.take_damage(4,priest.global_position)		
