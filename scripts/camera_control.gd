extends Camera3D

# Vitesse de déplacement et de rotation
@export var move_speed: float = 10.0
@export var sprint_multiplier: float = 2.0
@export var look_sensitivity: float = 0.1

# Variables pour stocker la rotation
var rotation_x: float = 0.0
var rotation_y: float = 0.0

# Fonction appelée lors du démarrage
func _ready():
	# Capturer la souris
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Gestion des événements d'entrée (souris pour regarder)
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * look_sensitivity
		rotation_x -= event.relative.y * look_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)  # Limiter la rotation verticale

# Déplacement et application des rotations
func _process(delta: float):
	# Appliquer la rotation à la caméra
	rotation_degrees.x = rotation_x
	rotation_degrees.y = rotation_y

	# Calcul du vecteur de direction
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

	# Ajuster la vitesse (avec ou sans sprint)
	var speed: float = move_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier

	# Déplacer la caméra
	position += direction.normalized() * speed * delta
