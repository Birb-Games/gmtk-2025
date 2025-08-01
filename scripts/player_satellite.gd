class_name Player

extends Area2D

const REVERSE_COOLDOWN: float = 0.2
const SHOOT_COOLDOWN: float = 0.2

@onready var level: Level = $/root/Main/Level
@export var orbital_speed: float = 100.0
@export var speed: float = 120.0
@export var min_dist: float = 128.0
@export var max_dist: float = 400.0
@export var bullet_scene: PackedScene
@export var debris_scene: PackedScene
var reverse_timer: float = 0.0
var shoot_timer: float = 0.0

const DAMAGE_TIME: float = 1.0
var damage_timer: float = 0.0
const MAX_HEALTH: int = 20
var health: int = MAX_HEALTH

func get_health_perc() -> float:
	return float(health) / float(MAX_HEALTH)

func move(delta: float) -> void:
	var dist = position.length()

	var movement_angle: Angle = Angle.from_radians(-get_vel().angle())
	var angle_from_planet: Angle = Angle.from_radians(-(position - get_parent().position).angle())
	var desired_movement_vector: Vector2 = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
	if desired_movement_vector.length() == 0.0:
		return
	var desired_movement_angle: Angle = Angle.from_radians(-desired_movement_vector.angle())

	if (movement_angle.minus(desired_movement_angle)).get_degrees() > 135 and (movement_angle.minus(desired_movement_angle)).get_degrees() < 225.0:
			orbital_speed *= -1.0
			reverse_timer = REVERSE_COOLDOWN

func move(delta: float) -> void:
	var dist = position.length()
	if Input.is_action_pressed("away_from_planet"):
		dist += speed * delta
	if Input.is_action_pressed("towards_planet"):
		dist -= speed * delta
	var angle = position.angle()
	dist = clamp(dist, min_dist, max_dist)
	position = dist * Vector2(cos(angle), sin(angle))

func shoot() -> void:
	if shoot_timer > 0.0:
		return
	if Input.is_action_pressed("shoot"):
		shoot_timer = SHOOT_COOLDOWN
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.rotation = rotation
		bullet.position = $BulletSpawnPos.global_position
		level.add_child(bullet)

func get_vel() -> Vector2:
	return Vector2(-position.y, position.x).normalized() * orbital_speed

func _process(delta: float) -> void:
	if damage_timer > 0.0:	
		damage_timer -= delta

	reverse_timer -= delta
	move(delta)

	# Rotate around center (0, 0)
	position += get_vel() * delta

	# Set rotation
	var diff = get_global_mouse_position() - global_position
	var angle = diff.angle()
	rotation = angle + PI / 2.0	

	shoot_timer -= delta
	shoot()

	if health <= 0:
		explode()

func explode():
	for i in range(15):
		var angle = randf() * 2.0 * PI
		var debris: SpaceObject = debris_scene.instantiate()
		var dist = randf() * 15.0
		var debris_scale = randf_range(0.25, 0.5)
		debris.scale = Vector2(debris_scale, debris_scale)
		debris.position = position + dist * Vector2(cos(angle), sin(angle))
		debris.velocity = Vector2(cos(angle), sin(angle)) * 80.0
		level.call_deferred("add_child", debris)
	queue_free()

func damage(amt: int) -> void:
	health -= amt
	damage_timer = DAMAGE_TIME

func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		if area.is_debris:
			damage(1)
		else:
			health = 0
	elif area is Debris or area is Bullet:
		damage(1)
	elif area is SpaceObject or area is EnemySatellite:
		health = 0

# This class is used to store angles, ensures that angles are always properly wrapped and handles units
class Angle:
	var angle: float

	func _init(a: float) -> void:
		self.angle = a

	static func from_degrees(degrees: float) -> Angle:
		return Angle.new(wrapf(degrees, 0, 360) * (PI / 180.0))

	static func from_radians(radians: float) -> Angle:
		return Angle.new(wrapf(radians, 0, 2 * PI))

	func get_degrees() -> float:
		return self.angle * (180.0 / PI)
	
	func get_radians() -> float:
		return self.angle
	
	func set_degrees(degrees: float) -> void:
		self.angle = wrapf(degrees, 0, 360) * (PI / 180.0)

	func set_radians(radians: float) -> void:
		self.angle = wrapf(radians, 0, 2 * PI)

	func plus(angle: Angle) -> Angle:
		return Angle.from_radians(wrapf(self.angle + angle.angle, 0, 2 * PI))

	func minus(angle: Angle) -> Angle:
		return Angle.from_radians(wrapf(self.angle - angle.angle, 0, 2 * PI))
