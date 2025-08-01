extends EnemySatellite

# In degrees
@export var rotation_speed: float = 180.0

func update_rotation(delta: float):
	# Set rotation
	rotation += deg_to_rad(rotation_speed) * delta
