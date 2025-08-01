class_name GravitySim

# Gravitational constant
const GRAVITY_CONST: float = 5000.0

# Get the force object2 is exerting on object1
static func get_gravity_force(object1: SpaceObject, object2: SpaceObject) -> Vector2:
	var dist = (object1.position - object2.position).length()

	# Do not process if the objects are too close to each other
	if dist < 0.001:
		return Vector2.ZERO

	var diff = (object2.position - object1.position).normalized()
	var mag = GRAVITY_CONST * object1.mass * object2.mass / (dist * dist)
	return mag * diff
