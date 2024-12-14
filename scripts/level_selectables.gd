extends Node3D

var selectable_model: PackedScene
var dragged_instance = null
const DEFAULT_PLANE = Plane(Vector3.UP, 0)
const MAX_RAYCAST_DISTANCE = 1000

func start_dragging():
	add_child(dragged_instance)
	var mouse_position_3d = get_mouse_position_on_plane()
	if mouse_position_3d:
		dragged_instance.global_transform.origin = mouse_position_3d

func stop_dragging():
	dragged_instance.enable_model()
	dragged_instance = null
	selectable_model = null

func cancel_dragging():
	if is_instance_valid(dragged_instance):
		dragged_instance.queue_free()
	dragged_instance = null
	selectable_model = null

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT and dragged_instance:
				stop_dragging()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				cancel_dragging()
	elif event is InputEventMouseMotion and dragged_instance:
		# Mettre à jour la position de l'instance pour suivre la souris sur le plan
		var mouse_position_3d = get_mouse_position_on_plane()
		if mouse_position_3d:
			dragged_instance.global_transform.origin = mouse_position_3d

func get_dynamic_plane(ray_origin, ray_direction) -> Plane :
	var space_state = get_world_3d().direct_space_state
	var from = ray_origin
	var to = from + ray_direction * MAX_RAYCAST_DISTANCE
	const collision_mask = 1 & ~2 & ~4
	# Configurer le RayCast3D pour détecter les objets sous la souris
	var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask, [self])
	query.collide_with_areas = true
	var collision = space_state.intersect_ray(query)

	if collision:
		# Obtenir les informations de collision
		# Définir un nouveau plan basé sur la surface touchée
		return Plane(collision.normal, collision.position)

	# IMPORTANT : Par défaut, si le Raycast fail, retourne le Plane par défaut (on met l'objet à Y = 0)
	return DEFAULT_PLANE

func get_mouse_position_on_plane():
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return null
	var ray_origin = camera.project_ray_origin(get_viewport().get_mouse_position())
	var ray_direction = camera.project_ray_normal(get_viewport().get_mouse_position())
	# Lorsque l'on arrive ici, fais un Raycast pour connaître le point d'ancrage de l'objet en-dessous de la souris
	var plane = get_dynamic_plane(ray_origin, ray_direction)
	# Calculer l'intersection entre le rayon et le nouveau plan
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	return intersection

func _on_game_ui_selectable_model_selected(passed_selectable_model):
	selectable_model = passed_selectable_model
	if selectable_model:
		dragged_instance = selectable_model.instantiate()
		dragged_instance.disable_model()
		start_dragging()

func _on_camera_slow_motion_toggled(toggled: bool):
	if (toggled == false):
		cancel_dragging()
