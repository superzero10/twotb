extends Node3D

@export var impulse_force = 10

@onready var area_3d = $Area3D

# Stocke les corps entrants pour appliquer l'impulsion constante
var affected_bodies: Array[PhysicsBody3D] = []

#func _on_area_3d_body_entered(body):
	#if body is RigidBody3D:
		## Calculer une direction pour la propulsion
		#var direction = -transform.basis.z.normalized()
		#var distance = (body.global_transform.origin - global_transform.origin).length()
		#var strength = impulse_force / (1.0 + distance)
		#body.apply_force(direction * strength, Vector3.ZERO)

func _on_body_entered(body: Node):
	if body is PhysicsBody3D:  # Vérifie que c'est un corps physique
		affected_bodies.append(body)

func _on_body_exited(body: Node):
	if body is PhysicsBody3D and body in affected_bodies:
		affected_bodies.erase(body)

func _process(delta: float) -> void:
	for body in affected_bodies:
		# Vérifie si le corps est toujours valide
		if body and body.is_inside_tree():
			# Calculer une direction pour la propulsion
			var direction = -transform.basis.z.normalized()
			var distance = (body.global_transform.origin - global_transform.origin).length()
			var strength = impulse_force / (1.0 + distance)
			# Applique une impulsion constante
			body.apply_central_impulse(direction * strength * delta)

func toggle(newActive: bool):
	area_3d.set_monitoring(newActive)
