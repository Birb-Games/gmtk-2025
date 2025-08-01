class_name EnemySatellite

extends Area2D

@onready var level: Level = $/root/Main/Level

@export var health_bar_grad: Gradient

@export var shoot_cooldown: float = 1.0
@export var orbital_speed: float = 100.0
@export var speed: float = 120.0
@export var bullet_scene: PackedScene
@export var debris_scene: PackedScene
var shoot_timer: float = 0.0

@export var max_health: int = 10
var health: int

func _ready() -> void:
	shoot_timer = shoot_cooldown
	health = max_health
	if randi() % 2 == 0:
		orbital_speed *= -1.0

func shoot() -> void:
	if shoot_timer > 0.0:
		return
	shoot_timer = shoot_cooldown
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.rotation = rotation
	bullet.position = $BulletSpawnPos.global_position
	bullet.enemy_bullet = true
	level.add_child(bullet)

func get_vel() -> Vector2:
	return Vector2(-position.y, position.x).normalized() * orbital_speed

func get_health_perc() -> float:
	return clamp(float(health) / float(max_health), 0.0, 1.0)

func _process(delta: float) -> void:
	# Rotate around center (0, 0)
	position += get_vel() * delta
	# Set rotation
	var player = level.get_node_or_null("PlayerSatellite")
	if player != null:
		var angle = (player.position - position).angle() + deg_to_rad(90.0)
		rotation = angle
		shoot_timer -= delta
	
	shoot()

	if health <= 0:
		explode()

	if get_health_perc() >= 1.0:
		$Background.hide()
	else:
		$Background.show()
	$Background/Healthbar.scale.x = get_health_perc()
	$Background/Healthbar.color = health_bar_grad.sample(get_health_perc())

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
	if area is Bullet:
		if !area.enemy_bullet:
			health -= 1
	elif area is Debris:
		health -= 1
	elif area is Asteroid and area.is_debris:
		health -= 1
	elif area is Player:
		health = 0
