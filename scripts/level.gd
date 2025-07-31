class_name Level 

extends Node2D

@export var center_object: SpaceObject

@export var asteroid_scene: PackedScene

@export var asteroid_spawn_time: float = 10.0
var asteroid_timer: float

func _ready() -> void:
	asteroid_timer = asteroid_spawn_time / 2.0

	# Gather all space objects, including asteroids
	var space_objects: Array[Node] = get_children()
	for child in space_objects:
		if child.name.contains("Asteroid"):
			space_objects.append_array(child.get_children())

	# Set the speeds of the objects
	for child in space_objects:
		if child is SpaceObject:
			if child.is_static:
				continue
			if !child.orbit:
				continue
			child.set_orbit(center_object)

func spawn_asteroid() -> void:
	# Spawn asteroid
	var asteroid: SpaceObject = asteroid_scene.instantiate()
	var player_satellite = get_node_or_null("PlayerSatellite")
	if player_satellite == null:
		return
	# Generate random position
	var dist = randf_range(player_satellite.min_dist, player_satellite.max_dist)
	var angle = randf() * 2.0 * PI
	var pos = Vector2(cos(angle), sin(angle)) * dist
	if (pos - player_satellite.position).length() < 100.0:
		return
	asteroid.position = pos
	asteroid.set_orbit(center_object)
	add_child(asteroid)

func _process(delta: float) -> void:
	asteroid_timer -= delta
	if asteroid_timer < 0.0:
		asteroid_timer = asteroid_spawn_time
		spawn_asteroid()	

func get_total_gravity_force(object: SpaceObject) -> Vector2:
	var total_force: Vector2 = Vector2.ZERO
	for child in get_children():
		if child is SpaceObject:
			if child is Asteroid:
				continue
			if child is Debris:
				continue
			total_force += GravitySim.get_gravity_force(object, child)
	return total_force
