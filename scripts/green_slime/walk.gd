extends State

@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var green_slime: CharacterBody2D = $"../.."
@onready var timer: Timer = $"../../Timer"
	
func physics_update(delta: float) -> void:
	
	var speed = 100.0
	green_slime.velocity.x = green_slime.direction * speed
	
	animation.play("walk")

	
	if green_slime.direction == 1:
		animation.flip_h = true
	elif green_slime.direction == -1:
		animation.flip_h = false
		
	green_slime.move_and_slide()
	if green_slime.is_on_wall():
		transitioned.emit("Idle")
		return
	


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name == "ruby":
		pass
