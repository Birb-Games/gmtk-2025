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

const MAX_HEALTH: int = 20
var health: int = MAX_HEALTH

func get_health_perc() -> float:
	return float(health) / float(MAX_HEALTH)

func reverse_dir() -> void:
	if reverse_timer > 0.0:
		return

	if Input.is_action_just_pressed("left"):
		if orbital_speed > 0.0:
			orbital_speed *= -1.0
			reverse_timer = REVERSE_COOLDOWN
	if Input.is_action_just_pressed("right"):
		if orbital_speed < 0.0:
			orbital_speed *= -1.0
			reverse_timer = REVERSE_COOLDOWN

func move(delta: float) -> void:
	var dist = position.length()
	if Input.is_action_pressed("up"):
		dist += speed * delta
	if Input.is_action_pressed("down"):
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
	move(delta)
	# Rotate around center (0, 0)
	position += get_vel() * delta

	# Set rotation
	var diff = get_global_mouse_position() - global_position
	var angle = diff.angle()
	rotation = angle + PI / 2.0	

	reverse_timer -= delta
	reverse_dir()

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

func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		if area.is_debris:
			health -= 1
		else:
			health = 0
	elif area is Debris or area is Bullet:
		health -= 1
	elif area is SpaceObject or area is EnemySatellite:
		health = 0
