class_name SpaceObject

extends Area2D

@onready var level = $/root/Main/Level

# If this is true, then the object will still have gravity but will not be
# pulled by other objects
@export var is_static: bool = false
# Initial velocity
@export var initial_vel: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
@export var mass: float = 1.0
@export var orbit: bool = true

func _ready() -> void:
	if initial_vel.length() > 0.0:
		velocity = initial_vel

func simulate_physics(delta: float) -> void:
	position += velocity * delta / 2.0
	if !is_static:
		var force = level.get_total_gravity_force(self)
		var acceleration = force / mass
		velocity += acceleration * delta
	position += velocity * delta / 2.0

func _process(delta: float) -> void:
	simulate_physics(delta)

func set_orbit(center_object: SpaceObject) -> void:
	if is_static:
		return
	var diff = position - center_object.position
	var dist = diff.length()
	if dist < 0.001:
		return
	var force = GravitySim.get_gravity_force(self, center_object)
	# v^2 / r * mass = force
	var speed = sqrt(dist * force.length() / mass)
	var dir = Vector2(-diff.y, diff.x)
	velocity = dir.normalized() * speed
	if randi() % 2 == 0:
		velocity *= -1.0

