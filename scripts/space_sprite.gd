extends Sprite2D

# in radians
@export var rotation_speed: float = PI / 4.0

func _ready() -> void:
	rotation = randf() * 2.0 * PI

func _process(delta: float) -> void:
	rotate(rotation_speed * delta)
