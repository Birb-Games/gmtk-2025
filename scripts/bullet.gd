class_name Bullet

extends SpaceObject

const BULLET_SPEED: float = 800.0

const MAX_TIME: float = 10.0
var timer: float = 0.0

func _ready() -> void:
	var angle = rotation - deg_to_rad(90.0)
	velocity = Vector2(cos(angle), sin(angle)) * BULLET_SPEED

func get_initial_vel() -> Vector2:
	var angle = rotation - deg_to_rad(90.0)
	return Vector2(cos(angle), sin(angle)) * BULLET_SPEED

func _process(delta: float) -> void:
	position += velocity * delta / 2.0
	var force = solar_system.get_total_gravity_force(self)
	var acceleration = force / mass
	velocity += acceleration * delta
	position += velocity * delta / 2.0	

	if timer > MAX_TIME:
		queue_free()
	timer += delta

func _on_area_entered(area: Area2D) -> void:
	if area is SpaceObject:
		queue_free()
