extends Node3D

# Signal pour permettre au Sélecteur de modèle de se mettre à jour
signal slow_motion_toggled

# Vitesse de déplacement et de rotation
@export var move_speed: float = 10.0
@export var sprint_multiplier: float = 2.0
@export var look_sensitivity: float = 0.1

# Variables pour stocker la rotation
var rotation_x: float = 0.0
var rotation_y: float = 0.0
var camera_active = true
var ignore_mouse_input = false  # Variable pour ignorer les entrées de la souris temporairement
var is_slow_motion = false  # Suivi de l'état du slow motion

# Facteur de ralentissement
@export var slow_motion_scale: float = 0.2  # Valeur entre 0.0 et 1.0
@export var slow_motion_transition_speed: float = 5.0  # Transition vers le slow motion
@export var stop_transition_speed: float = 9.5  # Transition vers l'arrêt progressif

# Variables pour gérer la vitesse et l'arrêt progressif
var current_direction: Vector3 = Vector3.ZERO  # Direction actuelle
var current_speed: float = 0.0  # Vitesse actuelle

# Fonction appelée lors du démarrage
func _ready():
	# Capturer la souris
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Gestion des événements d'entrée (souris pour regarder)
func _input(event: InputEvent):
	if ignore_mouse_input and event is InputEventMouseMotion:
		return

	if camera_active and event is InputEventMouseMotion:
		rotation_y -= event.relative.x * look_sensitivity
		rotation_x -= event.relative.y * look_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)  # Limiter la rotation verticale
		rotate_camera()

# Déplacement et application des rotations
func _process(delta: float):
	# Vérifier si la touche Alt est pressée pour activer ou désactiver le slow motion
	if Input.is_action_pressed("alt"):
		if camera_active:  # Si on active le slow motion
			activate_slow_motion()
	else:
		if is_slow_motion:  # Si on désactive le slow motion
			deactivate_slow_motion()

	# Transition vers le slow motion ou retour à la vitesse normale
	if is_slow_motion:
		Engine.time_scale = lerp(Engine.time_scale, slow_motion_scale, delta * slow_motion_transition_speed)
	else:
		Engine.time_scale = lerp(Engine.time_scale, 1.0, delta * slow_motion_transition_speed)

	# Appliquer les mouvements (normaux ou ralentis)
	if camera_active or is_slow_motion:
		apply_progressive_movement(delta)

func activate_slow_motion():
	slow_motion_toggled.emit(true)
	camera_active = false
	is_slow_motion = true
	ignore_mouse_input = true  # Ignorer temporairement les mouvements de souris
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Libère la souris
	# Geler la direction actuelle
	current_direction = calculate_current_direction()
	current_speed = move_speed  # Initialiser à la vitesse normale

func deactivate_slow_motion():
	slow_motion_toggled.emit(false)
	camera_active = true
	is_slow_motion = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture la souris
	ignore_mouse_input = false  # Réactive la gestion de la souris
	current_speed = 0.0  # Réinitialiser la vitesse après l'arrêt

func calculate_current_direction() -> Vector3:
	# Calcul du vecteur de direction basé sur les entrées clavier
	var direction: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):  # Z
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):  # S
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):  # Q
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):  # D
		direction += transform.basis.x
	if Input.is_action_pressed("move_up"):  # Espace
		direction += transform.basis.y
	if Input.is_action_pressed("move_down"):  # Shift
		direction -= transform.basis.y
	return direction.normalized()

func apply_progressive_movement(delta: float):
	if is_slow_motion:
		# Réduire la vitesse progressivement vers zéro
		current_speed = lerp(current_speed, 0.0, delta * stop_transition_speed)

		# Déplacer la caméra dans la direction figée avec la vitesse réduite
		position += current_direction * current_speed * delta
	elif camera_active:
		# Appliquer la rotation actuelle aux axes
		rotation_degrees.x = rotation_x
		rotation_degrees.y = rotation_y

		# Calculer la direction dynamique si la caméra est active
		var direction = calculate_current_direction()

		# Ajuster la vitesse (avec ou sans sprint)
		var speed: float = move_speed
		if Input.is_action_pressed("sprint"):
			speed *= sprint_multiplier

		# Déplacer la caméra
		position += direction * speed * delta

func rotate_camera():
	# Applique la rotation actuelle aux axes
	rotation_degrees.x = rotation_x
	rotation_degrees.y = rotation_y
