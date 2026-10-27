extends Area2D

const speed = 400
const turn_speed = 0.0
const lifetime = 5.0
var target : CharacterBody2D
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target:
		velocity = (target.global_position - global_position).normalized() * speed
		
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if target:
		var target_direction = (target.global_position - global_position).normalized()
		velocity = velocity.lerp(target_direction * speed, turn_speed*delta)
		
	global_position += velocity * delta
	


func _on_body_entered(body: Node2D) -> void:
	if body.name == "ruby":
		body.take_damage(2,global_position)
		queue_free()
