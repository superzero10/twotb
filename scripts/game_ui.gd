extends PanelContainer

@onready var selectables = $VBoxContainer
@onready var death_screen = $DeathScreen
@onready var victory_screen = $VictoryScreen
@onready var restart_buttons = [
	$DeathScreen/RestartButton,
	$VictoryScreen/RestartButton
]
@onready var quit_buttons = [
	$DeathScreen/QuitButton,
	$VictoryScreen/QuitButton
]
@onready var time_and_stars_label = $VictoryScreen/TimeAndStarsLabel

@export var camera: Node:
	set = set_camera_reference

@export var draggable_manager: Node:
	set = set_draggable_manager

signal selectable_model_selected

func set_camera_reference(value):
	camera = value
	if not is_inside_tree():
		await ready

func set_draggable_manager(value):
	draggable_manager = value
	if not is_inside_tree():
		await ready

func _ready():
	# Masquer les écrans au démarrage
	death_screen.visible = false
	victory_screen.visible = false

	# Connecter les boutons Restart
	for restart_button in restart_buttons:
		restart_button.connect("pressed", _on_restart_pressed)

	# Connecter les boutons Quit
	for quit_button in quit_buttons:
		quit_button.connect("pressed", _on_quit_pressed)

	# Si le joueur appuie sur "Alt", la caméra émet un signal "slow_motion_toggled"
	# On peut afficher ou cacher le menu ici
	camera.connect("slow_motion_toggled", set_selectables_visiblity)

func _on_selectables_selectable_model_selected(selectable_model):
	selectable_model_selected.emit(selectable_model)

func set_selectables_visiblity(visible: bool):
	# Ne pas permettre de modifier les sélections ou récupérer la souris si la partie est terminée
	selectables.visible = visible
	if not visible:
		draggable_manager.cancel_dragging()

func update_timer(time_left):
	$TimerLabel.text = str(floor(time_left))

func round_to_decimals(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func update_chronometer(time_elapsed):
	$ChronometerLabel.text = str(round_to_decimals(time_elapsed, 1))

func show_victory(stars, time_elapsed):
	# Mettre à jour les données de l'écran de victoire
	time_and_stars_label.text = "Temps : %.2fs\nÉtoiles : %d" % [time_elapsed, stars]
	victory_screen.visible = true

	# Libérer la souris définitivement
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Cacher le chronomètre
	$TimerLabel.hide()

func show_game_over(message):
	# Afficher l'écran de mort
	$DeathScreen/Label.text = message
	death_screen.visible = true

	# Libérer la souris définitivement
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Cacher le chronomètre
	$TimerLabel.hide()

# Gestion des boutons
func _on_restart_pressed():
	# Recharger la scène actuelle
	get_tree().reload_current_scene()
	# Capturer la souris à nouveau
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Réinitialiser l'état de la partie
	Global.GameHasFinished = false

func _on_quit_pressed():
	# Retourner au menu principal
	get_tree().change_scene_to_file("res://scenes/menu/LevelSelector.tscn")
