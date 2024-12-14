extends Node3D

# Références aux éléments de la scène
@onready var ball = $Ball  # Référence à la balle (RigidBody3D)
@onready var timer = $Timer  # Référence au Timer
@onready var ui_label = $GameUI/Label  # Référence au Label pour le compte à rebours

@export var start_position: Vector3 = Vector3(0, 5, 0)  # Position de départ de la balle

func _ready():
	# Initialisation de la balle
	setup_ball()
	setup_ui()
	start_countdown()

func setup_ball():
	ball.mode = RigidBody3D.MODE_STATIC  # Désactiver la physique de la balle au début
	ball.global_transform.origin = start_position  # Positionner la balle au point de départ

func setup_ui():
	ui_label.text = "5"  # Initialiser le texte du compte à rebours
	ui_label.visible = true  # Rendre le label visible

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
