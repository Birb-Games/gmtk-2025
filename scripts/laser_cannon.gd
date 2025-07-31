extends AnimatedSprite2D

@onready var solar_system: SolarSystem = $/root/Main/SolarSystem

@export var bullet_scene: PackedScene

var SHOOT_COOLDOWN: float = 0.5
var shoot_timer: float = 0.0

func _process(delta: float) -> void:
	if shoot_timer > 0.0:
		shoot_timer -= delta

	if shoot_timer > SHOOT_COOLDOWN / 4.0:
		if animation != "not_ready":
			animation = "not_ready"
	else:
		if animation != "ready":
			animation = "ready"	

# Returns the force of the object
func shoot() -> Vector2:
	if shoot_timer <= 0.0 and Input.is_action_pressed("shoot"):
		shoot_timer = SHOOT_COOLDOWN
		var bullet = bullet_scene.instantiate()
		bullet.position = $BulletSpawnPos.global_position
		bullet.rotation = global_rotation
		solar_system.get_node("Bullets").add_child(bullet)
		var vel = bullet.get_initial_vel()
		return vel * bullet.mass
	return Vector2.ZERO
