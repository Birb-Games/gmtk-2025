class_name Bullet

extends Area2D

const BULLET_SPEED: float = 300.0

var velocity: Vector2 = Vector2.ZERO
const MAX_TIME: float = 10.0
var timer: float = 0.0

func _ready() -> void:
	var angle = rotation - deg_to_rad(90.0)
	velocity = Vector2(cos(angle), sin(angle)) * BULLET_SPEED

func get_initial_vel() -> Vector2:
	var angle = rotation - deg_to_rad(90.0)
	return Vector2(cos(angle), sin(angle)) * BULLET_SPEED

func _process(delta: float) -> void:
	position += velocity * delta
	if timer > MAX_TIME:
		queue_free()
	timer += delta

func _on_area_entered(area: Area2D) -> void:
	if area is SpaceObject:
		queue_free()
