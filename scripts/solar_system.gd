class_name SolarSystem

extends Node2D

# Gravitational constant
const GRAVITY_CONST: float = 5000.0

@export var rogue_planet_speed: float = 10.0
@export var star: SpaceObject
@export var rogue_planet_scene: PackedScene
var rogue_planet_spawn_timer: float = 0.0
const ROGUE_PLANET_SPAWN_DELAY: float = 45.0

func spawn_rogue_planet() -> void:
	var homeworld = get_node_or_null("Homeworld")
	if homeworld == null:
		return
	# Generate random position for the rogue planet
	var angle = randf() * 2.0 * PI
	var pos = Vector2(cos(angle), sin(angle)) * 3000.0
	var rogue_planet: SpaceObject = rogue_planet_scene.instantiate()
	rogue_planet.position = pos
	rogue_planet.velocity = (homeworld.position - rogue_planet.position).normalized() * rogue_planet_speed
	add_child(rogue_planet)

func _ready() -> void:
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
			if !child.orbit_sun:
				continue
			var diff = child.position - star.position
			var dist = diff.length()
			if dist < 0.001:
				continue
			var force = get_gravity_force(child, star)
			# v^2 / r * mass = force
			var speed = sqrt(dist * force.length() / child.mass)
			var dir = Vector2(-diff.y, diff.x)
			child.velocity = dir.normalized() * speed

func _process(delta: float) -> void:
	if rogue_planet_spawn_timer > 0.0:
		rogue_planet_spawn_timer -= delta
	
	if rogue_planet_spawn_timer <= 0.0:
		rogue_planet_spawn_timer = ROGUE_PLANET_SPAWN_DELAY
		spawn_rogue_planet()

# Get the force object2 is exerting on object1
static func get_gravity_force(object1: SpaceObject, object2: SpaceObject) -> Vector2:
	var dist = (object1.position - object2.position).length()

	# Do not process if the objects are too close to each other
	if dist < 0.001:
		return Vector2.ZERO

	var diff = (object2.position - object1.position).normalized()
	var mag = GRAVITY_CONST * object1.mass * object2.mass / (dist * dist)
	return mag * diff

func get_total_gravity_force(object: SpaceObject) -> Vector2:
	var total_force: Vector2 = Vector2.ZERO
	for child in get_children():
		if child is SpaceObject:
			total_force += get_gravity_force(object, child)
	return total_force
