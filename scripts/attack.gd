#player attack script

extends State
var attack_buffered = false
var attack_hit = false
@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var ruby: CharacterBody2D = $"../.."
@onready var attack_area: Area2D = $"../../attack_area"
@export var swing_sfx: AudioStream
func enter() -> void:
	attack_hit = false
	
	animation.play("attack")
	SoundManager.play_sfx(swing_sfx, 0.1, -30.0)
func physics_update(delta: float) -> void:
	ruby.velocity.y += GlobalScript.GRAVITY * delta

	var direction = Input.get_axis("ui_left","ui_right")
	ruby.velocity.x = direction * GlobalScript.SPEED
	ruby.move_and_slide()
	if Input.is_action_just_pressed("Mouse_Left"):
		attack_buffered = true
		
	if direction == 1:
		animation.flip_h = false
	elif direction == -1:
		animation.flip_h = true
		
func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "attack":			
		if attack_buffered:
			attack_buffered = false
			
			enter()
			return 
			
		var direction = Input.get_axis("ui_left","ui_right")
		ruby.velocity.x = direction * GlobalScript.SPEED
		if ruby.is_on_floor():
			if direction !=0:
				transitioned.emit("run")		
			else:
				transitioned.emit("idle")		
		else:
			transitioned.emit("fall")
			
func deal_attack_damage() -> void:
	var targets = attack_area.get_overlapping_bodies()

	for body in targets:
		if body.is_in_group("peds"):
			body.take_damage(1)
		
		elif body.is_in_group("boar"):
			body.take_damage(1,ruby.global_position)
		
		elif body.is_in_group("mushroom"):
			body.take_damage(1,ruby.global_position)
		
		elif body.is_in_group("priest"):
			body.take_damage(1,ruby.global_position)
		
		elif body.is_in_group("martial_hero"):
			body.take_damage(1,ruby.global_position)

func _on_animated_sprite_2d_frame_changed() -> void:
	if animation.animation == "attack" and animation.frame >=2:
		if not attack_hit:
			attack_hit = true
			deal_attack_damage()
func exit() -> void:
	attack_buffered = false
	attack_hit = false
