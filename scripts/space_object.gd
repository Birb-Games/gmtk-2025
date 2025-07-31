class_name SpaceObject

extends Area2D

@onready var solar_system: SolarSystem = $/root/Main/SolarSystem

@onready var asteroid_scene: PackedScene = preload("uid://dgc6sxp0v4uf6")

# If this is true, then the object will still have gravity but will not be
# pulled by other objects
@export var is_static: bool = false
# Initial velocity
@export var initial_vel: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
@export var mass: float = 1.0
@export var orbit_sun: bool = true
var health: float = 0.0
var max_health: float = 0.0

@export var is_asteroid: bool = false

func _ready() -> void:
	if initial_vel.length() > 0.0:
		velocity = initial_vel
	health = mass
	max_health = health

func _process(delta: float) -> void:
	position += velocity * delta / 2.0
	if !is_static:
		var force = solar_system.get_total_gravity_force(self)
		var acceleration = force / mass
		velocity += acceleration * delta
	position += velocity * delta / 2.0

func explode() -> void:
	var asteroid_count = clamp(floor(mass * 3.0), 15, 25)
	if is_asteroid:
		asteroid_count = 0
	for i in range(asteroid_count):
		var angle = randf() * 2.0 * PI
		var asteroid: SpaceObject = asteroid_scene.instantiate()
		var dist = 15.0 + randf() * 15.0
		var asteroid_scale = randf_range(0.1, 0.5)
		asteroid.scale = Vector2(asteroid_scale, asteroid_scale)
		asteroid.position = position + dist * Vector2(cos(angle), sin(angle))
		asteroid.initial_vel = Vector2(cos(angle), sin(angle)) * 200.0
		solar_system.get_node("Debris").call_deferred("add_child", asteroid)
	queue_free()

func _on_area_entered(area: Area2D) -> void:	
	if area is Bullet:
		if is_asteroid:
			queue_free()
		elif !is_static:
			health -= 0.1
	if area is SpaceObject:
		if !is_static and !(is_asteroid and area.is_asteroid):
			health -= area.mass
		if health <= 0.0 and !is_static:
			explode()
