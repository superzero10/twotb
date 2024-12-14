extends Node3D

@export var impulse_force = 10

@onready var area_3d = $Area3D

func _on_area_3d_body_entered(body):
	if body is RigidBody3D:
		# Calculer une direction pour la propulsion
		var bumper_position = global_transform.origin
		var body_position = body.global_transform.origin
		var direction = (body_position - bumper_position).normalized()
		var impulse = direction * impulse_force

		# Appliquer une impulsion
		body.apply_central_impulse(impulse)
		#body.apply_impulse(bumper_position, direction * impulse_force)

func toggle(newActive: bool):
	area_3d.set_monitoring(newActive)
