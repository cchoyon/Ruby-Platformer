extends State

@onready var player = $"../.."
@onready var animation = $"../../AnimatedSprite2D"

func enter() -> void:
	animation.play("fall")
	
func physics_update(delta: float) -> void:
	player.velocity.y +=1.5* GlobalScript.GRAVITY * delta
	
	var direction = Input.get_axis("ui_left","ui_right")
	player.velocity.x = direction * GlobalScript.SPEED
	
	if direction == 1:
		animation.flip_h = false
	elif direction == -1:
		animation.flip_h = true
		
	player.move_and_slide()
	if Input.is_action_just_pressed("Mouse_Left"):
		transitioned.emit("attack")
		return
		
	if player.is_on_floor():
		if direction == 0:
			transitioned.emit("idle")
			return
		else:
			transitioned.emit("run")
			return
		
	
