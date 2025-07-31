extends Sprite2D

@onready var homeworld: SpaceObject = get_parent()

func _process(_delta: float) -> void:
	var diff: Vector2 = get_global_mouse_position() - global_position
	rotation = diff.angle() + deg_to_rad(90.0)
	homeworld.velocity -= $LaserCannon.shoot() / homeworld.mass
