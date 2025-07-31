extends Sprite2D

@onready var homeworld: SpaceObject = get_parent()

const ACCELERATION: float = 60.0

func _process(delta: float) -> void:
	var diff: Vector2 = get_global_mouse_position() - global_position
	rotation = diff.angle() + deg_to_rad(90.0)
	$LaserCannon.shoot()

	if Input.is_action_pressed("engines"):
		$RocketBooster.animation = "active"
		var angle = rotation - deg_to_rad(90.0)
		homeworld.velocity += Vector2(cos(angle), sin(angle)) * ACCELERATION * delta
	else:
		$RocketBooster.animation = "inactive"
