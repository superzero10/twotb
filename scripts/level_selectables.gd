extends Node3D

var selectable_model: PackedScene
var dragged_instance = null
var drag_plane = Plane(Vector3.UP, 1)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and selectable_model:
			if dragged_instance == null:
				# Charger la scène
				# Instancier la scène
				dragged_instance = selectable_model.instantiate()
				add_child(dragged_instance)
				# Initialiser la position de l'instance sur le plan
				var mouse_position_3d = get_mouse_position_on_plane()
				if mouse_position_3d:
					dragged_instance.global_transform.origin = mouse_position_3d
			else:
				# Relâcher l'objet
				dragged_instance = null
	elif event is InputEventMouseMotion and dragged_instance:
		# Mettre à jour la position de l'instance pour suivre la souris sur le plan
		var mouse_position_3d = get_mouse_position_on_plane()
		if mouse_position_3d:
			dragged_instance.global_transform.origin = mouse_position_3d

func get_mouse_position_on_plane():
	# Récupérer la caméra
	var camera = get_viewport().get_camera_3d()
	if camera:
		# Obtenir le rayon projeté par la souris
		var ray_origin = camera.project_ray_origin(get_viewport().get_mouse_position())
		var ray_direction = camera.project_ray_normal(get_viewport().get_mouse_position())
		# Calculer l'intersection du rayon avec le plan
		var intersection = drag_plane.intersects_ray(ray_origin, ray_direction)
		return intersection
	return null


func _on_game_ui_selectable_model_selected(passed_selectable_model):
	selectable_model = passed_selectable_model
