extends State

@onready var animation: AnimatedSprite2D = $"../../animation"
@onready var boar: CharacterBody2D = $"../.."
@onready var idle_timer: Timer = $idle_timer

func enter() -> void:
	animation.play("idle")
	boar.velocity.x = 0
	idle_timer.start()
func physics_update(delta: float) -> void:
	boar.velocity.y += GlobalScript.GRAVITY * delta
	boar.move_and_slide()
	
	if boar.direction == 1:
		animation.flip_h = true
	elif boar.direction == -1:
		animation.flip_h = false


func _on_idle_timer_timeout() -> void:
	transitioned.emit("walk")
	
func exit() -> void:
	idle_timer.stop()
