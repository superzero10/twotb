extends Node3D

@export var impulse_force = 10

@onready var area_3d = $Area3D

func _on_area_3d_body_entered(body):
	if body is RigidBody3D:
		# Calculer une direction pour la propulsion
		var impulse = Vector3.UP * impulse_force

		# Appliquer une impulsion
		body.apply_central_impulse(impulse)

func toggle(newActive: bool):
	area_3d.set_monitoring(newActive)