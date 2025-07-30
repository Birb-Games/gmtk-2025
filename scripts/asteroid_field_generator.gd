extends Node2D

@export var inner_radius: int = 700
@export var outer_radius: int = 900
@export var asteroid_count: int = 100

var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")

func _ready() -> void:
	for i in range(asteroid_count):
		var asteroid: SpaceObject = asteroid_scene.instantiate()
		var angle: float = randf() * 2.0 * PI
		var distance_from_sun: float = randf_range(inner_radius, outer_radius)
		asteroid.position = Vector2(cos(angle), sin(angle)) * distance_from_sun
		var asteroid_scale = randf_range(0.1, 0.5)
		asteroid.scale = Vector2(asteroid_scale, asteroid_scale)

		add_child(asteroid)
