extends State
@onready var player = $"../.."
@onready var animation = $"../../AnimatedSprite2D"

func physics_update(delta: float) -> void:
	player.velocity.y += GlobalScript.GRAVITY * delta
	if Input.is_action_just_pressed("Mouse_Left"):
		transitioned.emit("attack")
		return
		
	var direction = Input.get_axis("ui_left","ui_right")
	
	if direction !=0:
		player.velocity.x = direction * GlobalScript.SPEED
		if animation.animation != "run" or not animation.is_playing():
			animation.play("run")

		
	if direction ==1:
		animation.flip_h = false
	elif  direction ==-1:
		animation.flip_h = true
	
	player.move_and_slide()
	
	if direction == 0:
		transitioned.emit("idle")
		return
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		transitioned.emit("jump")
		return
	
	if not player.is_on_floor():
		transitioned.emit("fall")
		return
		

		
