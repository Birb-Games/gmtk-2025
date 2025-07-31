class_name SpaceObject

extends Area2D

@onready var solar_system: SolarSystem = $/root/Main/SolarSystem

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

var asteroid_debris: PackedScene = preload("res://scenes/asteroid.tscn")

func _ready() -> void:
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
	for i in range(mass / 5.0):
		var asteroid: SpaceObject = asteroid_debris.instantiate()
		asteroid.position = position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
		asteroid.initial_vel = velocity + Vector2(randf_range(-200, 200), randf_range(-200, 200))
		var asteroid_scale = randf_range(0.1, 0.5)
		asteroid.scale = Vector2(asteroid_scale, asteroid_scale)
		solar_system.call_deferred("add_child", asteroid)

	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is SpaceObject:
		if !is_static:
			health -= area.mass
		if health <= 0.0:
			explode()
