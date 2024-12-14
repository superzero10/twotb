extends Node3D

@export var impulse_force = 100:
	set = set_impulse_force

var active = true

func set_impulse_force(value):
	impulse_force = value
	if not is_inside_tree():
		await ready

func _on_area_3d_body_entered(body):
	if active and body is RigidBody3D:
		# Calculer une direction pour la propulsion
		var bumper_position = global_transform.origin
		var body_position = body.global_transform.origin
		var direction = (body_position - bumper_position).normalized()

		# Appliquer une impulsion
		body.apply_impulse(bumper_position, direction * impulse_force)
		print("Propulsion appliquée à :", body.name)

func toggle(newActive):
	active = newActive
