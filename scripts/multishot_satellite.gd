extends EnemySatellite

@export var bullet_count: int = 3
# In degrees
@export var spread: float = 30.0

func shoot() -> void:
	if shoot_timer > 0.0:
		return

	for i in range(0, bullet_count):
		shoot_timer = shoot_cooldown
		var bullet: Bullet = bullet_scene.instantiate()
		var offset = i * deg_to_rad(spread) / float(bullet_count) - deg_to_rad(spread) * 0.5
		bullet.rotation = rotation + offset
		bullet.position = $BulletSpawnPos.global_position
		bullet.enemy_bullet = true
		level.add_child(bullet)
