extends State


@onready var animation: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var state_machine = $".."
@onready var ruby: CharacterBody2D = $"../.."
@onready var death_ui: CanvasLayer = $"../../DeathUI"


func enter() -> void:
	death_ui.show()
	animation.play("dead")
	ruby.velocity.x = 0
	get_tree().paused = true
func physics_update(delta: float) -> void:
	ruby.velocity.y += GlobalScript.GRAVITY * delta
	ruby.move_and_slide()
	
