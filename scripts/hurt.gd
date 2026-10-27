#player hurt
extends State

@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var ruby: CharacterBody2D = $"../.."
var last_attacker_position = Vector2.ZERO
const Knockback_Strength_X = 500.0
const Knockback_Strength_Y = 200.0
var attack_buffered = false
var stun_time = 0.0

func enter() -> void:
	animation.play("hurt")
	attack_buffered = false
	var hit_direction = sign(ruby.global_position.x - last_attacker_position.x)
	if hit_direction ==0:
		hit_direction = -1 if animation.flip_h else 1
	ruby.velocity.x = hit_direction * Knockback_Strength_X
	if ruby.is_on_floor():
		ruby.velocity.y = -Knockback_Strength_Y
	
	stun_time = 0.3
	
func physics_update(delta: float) -> void:
	stun_time -= delta
	ruby.velocity.y+= GlobalScript.GRAVITY * delta
	
	var friction = 1200.0
	
	ruby.velocity.x = move_toward(ruby.velocity.x, 0, friction * delta)
		
	ruby.move_and_slide()
	if Input.is_action_just_pressed("Mouse_Left"):
		attack_buffered = true
	
	if stun_time < 0:
		if attack_buffered:
			transitioned.emit("attack")
			return
		var direction = Input.get_axis("ui_left","ui_right")
		ruby.velocity.x = direction * GlobalScript.SPEED
		if ruby.is_on_floor():
			if direction != 0:
				transitioned.emit("run")
			else:
				transitioned.emit("idle")
		else:
			transitioned.emit("fall")
