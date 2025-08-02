extends AnimatedSprite2D

var current_animation: int = 0

func reset() -> void:
	position.x = -256.0
	rotation = randf() * 2.0 * PI
	position.y = randf_range(200.0, 500.0)
	animation = "animation" + str(current_animation + 1)
	play(animation)

func _ready() -> void:
	reset()

func _process(delta: float) -> void:
	position += Vector2(128.0, 0.0) * delta
	rotation += delta

	if position.x > 1800.0:
		current_animation += 1
		current_animation %= 2
		reset()
