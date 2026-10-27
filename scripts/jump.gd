extends State
@onready var jump_strength = -sqrt(2.0 * GlobalScript.GRAVITY*150.0)
@onready var player = $"../.."
@onready var animation = $"../../AnimatedSprite2D"
const jump_cut = 0.2
const fall_gravity = 2.0

func enter() -> void:
	animation.play("jump")
	player.velocity.y = jump_strength
	
func physics_update(delta: float) -> void:
	player.velocity.y += GlobalScript.GRAVITY * delta
	
	var direction = Input.get_axis("ui_left","ui_right")
	player.velocity.x = direction * GlobalScript.SPEED
	if direction == 1:
		animation.flip_h = false
	elif direction == -1:
		animation.flip_h = true
		
	if Input.is_action_just_released("ui_accept"):
		player.velocity.y *= 0.3
	player.move_and_slide()
	
	if player.velocity.y >=0:
		transitioned.emit("fall")
		return
	
	if Input.is_action_just_pressed("Mouse_Left"):
		transitioned.emit("attack")
		return
