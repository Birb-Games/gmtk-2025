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

func _ready() -> void:
	velocity = initial_vel

func _process(delta: float) -> void:
	position += velocity * delta / 2.0
	if !is_static:
		var force = solar_system.get_total_gravity_force(self)
		var acceleration = force / mass
		velocity += acceleration * delta	
	position += velocity * delta / 2.0
