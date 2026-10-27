extends State
@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var green_slime: CharacterBody2D = $"../.."
@onready var timer: Timer = $"../../Timer"

func enter() -> void:
	timer.start(0.5)
	animation.play("idle")
	
func physics_update(delta: float) -> void:
	green_slime.velocity.x = 0
	green_slime.move_and_slide()
	
	
func _on_timer_timeout() -> void:
	green_slime.direction = -green_slime.direction
	transitioned.emit("Walk")
