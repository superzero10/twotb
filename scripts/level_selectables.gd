extends Node3D

var selectable_model: PackedScene
var dragged_instance = null
var drag_plane = Plane(Vector3.UP, 1)

func start_dragging(instance):
	add_child(dragged_instance)
	var mouse_position_3d = get_mouse_position_on_plane()
	if mouse_position_3d:
		dragged_instance.global_transform.origin = mouse_position_3d

func stop_dragging():
	dragged_instance = null
	selectable_model = null

func cancel_dragging():
	if is_instance_valid(dragged_instance):
		dragged_instance.queue_free()
	dragged_instance = null
	selectable_model = null

func toggle_dragging():
	if dragged_instance == null:
		dragged_instance = selectable_model.instantiate()
		start_dragging(dragged_instance)
	else:
		stop_dragging()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT and selectable_model:
				toggle_dragging()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				cancel_dragging()
	elif event is InputEventMouseMotion and dragged_instance:
		# Mettre à jour la position de l'instance pour suivre la souris sur le plan
		var mouse_position_3d = get_mouse_position_on_plane()
		if mouse_position_3d:
			dragged_instance.global_transform.origin = mouse_position_3d

func get_mouse_position_on_plane():
	var camera = get_viewport().get_camera_3d()
	if camera:
		var ray_origin = camera.project_ray_origin(get_viewport().get_mouse_position())
		var ray_direction = camera.project_ray_normal(get_viewport().get_mouse_position())
		var intersection = drag_plane.intersects_ray(ray_origin, ray_direction)
		return intersection
	return null

func _on_game_ui_selectable_model_selected(passed_selectable_model):
	selectable_model = passed_selectable_model
	if selectable_model:
		dragged_instance = selectable_model.instantiate()
		start_dragging(dragged_instance)
