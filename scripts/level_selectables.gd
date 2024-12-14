extends Node3D

# CONSTANTES
const DEFAULT_PLANE = Plane(Vector3.UP, 0) # Quand le joueur place un objet dans le vide
const MODEL_ROTATION_ANGLE = 30 # Quand le joueur veut effectuer une rotation d'un objet
const MAX_RAYCAST_DISTANCE = 10000 # Raycast pour placer un objet

# Références aux éléments de la scène
# Très important : Il faut toujours un "GameUi" dans le niveau
@onready var game_ui = $GameUi
@onready var ball = $Ball  # Référence à la balle (RigidBody3D)
@onready var timer = $Timer  # Référence au Timer
@onready var ui_label = $GameUI/Label  # Référence au Label pour le compte à rebours

@export var start_position: Vector3 = Vector3(0, 5, 0)  # Position de départ de la balle


var selectable_model: PackedScene
var dragged_instance = null

func _ready():
	# Initialisation de la balle
	setup_ball()
	setup_ui()
	start_countdown()
	
func start_dragging():
	if dragged_instance.has_method("disable_model"):
		dragged_instance.disable_model()
	add_child(dragged_instance)
	var mouse_position_3d = get_mouse_position_on_plane()
	if mouse_position_3d:
		dragged_instance.global_transform.origin = mouse_position_3d

func stop_dragging():
	if dragged_instance.has_method("enable_model"):
		dragged_instance.enable_model()
	dragged_instance = null
	selectable_model = null

func setup_ball():
	ball.mode = RigidBody3D.MODE_STATIC  # Désactiver la physique de la balle au début
	ball.global_transform.origin = start_position  # Positionner la balle au point de départ

func setup_ui():
	ui_label.text = "5"  # Initialiser le texte du compte à rebours
	ui_label.visible = true  # Rendre le label visible

func rotate_dragging(clockwise = true):
	if not dragged_instance:
		return
	var rotation = MODEL_ROTATION_ANGLE
	var angle = deg_to_rad(rotation)
	if clockwise:
		dragged_instance.rotate_y(angle)
	else:
		dragged_instance.rotate_y(-angle)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT and dragged_instance:
				stop_dragging()
			if event.button_index == MOUSE_BUTTON_RIGHT:
				cancel_dragging()
			if event.is_action_pressed("rotate_right") or event.is_action_pressed("rotate_left"):
				rotate_dragging(event.is_action_pressed("rotate_right"))
	elif event is InputEventMouseMotion and dragged_instance:
		# Mettre à jour la position de l'instance pour suivre la souris sur le plan
		var mouse_position_3d = get_mouse_position_on_plane()
		if mouse_position_3d:
			dragged_instance.global_transform.origin = mouse_position_3d

func start_countdown():
	timer.start()  # Démarrer le timer
	update_countdown()  # Lancer la mise à jour du compte à rebours

# Mettre à jour le compte à rebours
func update_countdown():
	while int(timer.time_left) > 0:
		var time_left = int(timer.time_left) + 1
		ui_label.text = str(time_left)
		await get_tree().create_timer(1.0).timeout  # Attendre 1 seconde

	await on_countdown_finished()

func on_countdown_finished():
	ui_label.text = "GO!"  # Afficher "GO!"
	ball.mode = RigidBody3D.MODE_RIGID  # Activer la physique de la balle
	await get_tree().create_timer(1.0).timeout  # Attendre une seconde
	ui_label.hide()  # Cacher le label

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
	cancel_dragging()
	selectable_model = passed_selectable_model
	if selectable_model:
		dragged_instance = selectable_model.instantiate()
		start_dragging()

func _on_camera_slow_motion_toggled(toggled: bool):
	game_ui.set_selectables_visiblity(toggled)
	if (toggled == false):
		cancel_dragging()
