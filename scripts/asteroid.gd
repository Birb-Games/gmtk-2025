class_name Asteroid

extends SpaceObject

var is_debris: bool = false

const LIFETIME = 10.0
var lifetime_timer = LIFETIME

var target_scale: float = 0.0
func _ready() -> void:
	target_scale = scale.x
	if !is_debris:
		scale = Vector2.ZERO

func _process(delta: float) -> void:
	if scale.x < target_scale:
		scale.x += delta
		scale.x = clamp(scale.x, 0.0, target_scale)
		scale.y = scale.x

	if is_debris:
		lifetime_timer -= delta
	if lifetime_timer < 0.0:
		queue_free()
		return
	simulate_physics(delta)

func explode() -> void:
	var asteroid_count = randi_range(8, 12)
	if is_debris:
		asteroid_count = 0
	for i in range(asteroid_count):
		var angle = randf() * 2.0 * PI
		var asteroid: SpaceObject = asteroid_scene.instantiate()
		var dist = randf() * 15.0
		var asteroid_scale = randf_range(0.25, 0.5)
		asteroid.scale = Vector2(asteroid_scale, asteroid_scale)
		asteroid.is_debris = true
		asteroid.position = position + dist * Vector2(cos(angle), sin(angle))
		asteroid.velocity = Vector2(cos(angle), sin(angle)) * 80.0
		level.call_deferred("add_child", asteroid)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		explode()
	if area is Player:
		explode()
	if area is SpaceObject and area is not Asteroid:
		explode()
