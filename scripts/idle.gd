extends State
@onready var player = $"../.."
@onready var animation = $"../../AnimatedSprite2D"

func enter():
	animation.play("idle")

func physics_update(delta: float) -> void:
	if not player.has_control:
		return
	if not player.is_on_floor():
		player.velocity.y += GlobalScript.GRAVITY * delta
		
	player.velocity.x = 0
	player.move_and_slide()
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		transitioned.emit("run")
		return
		
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		transitioned.emit("jump")
		return
	
	if Input.is_action_just_pressed("Mouse_Left"):
		transitioned.emit("attack")
		return
