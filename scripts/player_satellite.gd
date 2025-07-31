extends Area2D

const REVERSE_COOLDOWN: float = 0.2
const SHOOT_COOLDOWN: float = 0.2

@onready var level: Level = $/root/Main/Planet
@export var speed: float = 80.0
@export var min_dist: float = 128.0
@export var max_dist: float = 300.0
@export var bullet_scene: PackedScene
var reverse_timer: float = 0.0
var shoot_timer: float = 0.0

func reverse_dir() -> void:
	if reverse_timer > 0.0:
		return

	if Input.is_action_just_pressed("left"):
		if speed > 0.0:
			speed *= -1.0
			reverse_timer = REVERSE_COOLDOWN
	if Input.is_action_just_pressed("right"):
		if speed < 0.0:
			speed *= -1.0
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

func _process(delta: float) -> void:
	move(delta)
	# Rotate around center (0, 0)
	var vel = Vector2(-position.y, position.x).normalized()
	position += vel * speed * delta

	# Set rotation
	var diff = get_global_mouse_position() - global_position
	var angle = diff.angle()
	rotation = angle + PI / 2.0	

	reverse_timer -= delta
	reverse_dir()

	shoot_timer -= delta
	shoot()
