extends Node3D

@export var start_timer_duration: float = 2.0
@export var three_star_time: float = 20.0
@export var two_star_time: float = 40.0
@export var leaderboard_file: String = "user://leaderboard.save"

@onready var ball = $ball
@onready var countdown = $Countdown
@onready var timer_player = $TimerPlayer
@onready var countdown_label = $Player/GameUi/CountdownLabel
@onready var timer_player_label = $Player/GameUi/TimerLabel
@onready var game_ui = $Player/GameUi
@onready var camera_control = $Player/camera/CameraControl
@onready var finish_zone = $FinishZone2

var start_time: int = 0
var elapsed_time: float = 0.0
var leaderboard: Array = []
var can_restart = true

func _ready():
	# Connexion des signaux
	if not finish_zone.is_connected("body_entered", Callable(self, "_on_FinishZone_body_entered")):
		finish_zone.connect("body_entered", Callable(self, "_on_FinishZone_body_entered"))

	if not timer_player.is_connected("timeout", Callable(self, "_on_timer_player_timeout")):
		timer_player.connect("timeout", Callable(self, "_on_timer_player_timeout"))

	# Initialisation des temporisateurs
	game_ui.update_timer(start_timer_duration)
	countdown.wait_time = start_timer_duration
	countdown.one_shot = true
	countdown.start()

	# Initialisation de l'interface utilisateur
	countdown_label.text = str(floor(countdown.time_left))
	timer_player_label.text = "0.0"

	# Désactiver la balle au départ
	ball.freeze = true

	# Activer la caméra principale
	if camera_control is Camera3D:
		camera_control.make_current()
	else:
		print("Erreur : le nœud 'CameraControl' n'est pas une instance de Camera3D.")

	# Charger les scores
	load_leaderboard()

	# Prévenir les redémarrages multiples
	await get_tree().create_timer(1.0).timeout
	can_restart = true

func _input(event):
	if event.is_action_pressed("restart_level") and can_restart:
		print("Redémarrage du niveau")
		can_restart = false
		get_tree().reload_current_scene()

func _on_FinishZone_body_entered(body):
	if body == ball:
		elapsed_time = (Time.get_ticks_msec() - start_time) / 1000.0
		var stars = calculate_stars(elapsed_time)
		save_score(elapsed_time)
		game_ui.show_victory(elapsed_time, stars)


func _on_timer_player_timeout():
	print("TimerPlayer a déclenché un timeout.")

# Reste des fonctions (inchangé)
func _process(delta):
	# Mise à jour des étiquettes UI
	if countdown.time_left > 0:
		countdown_label.text = str(floor(countdown.time_left + 1))
	if not ball.freeze:
		elapsed_time += delta
		timer_player_label.text = str(round_to_decimals(elapsed_time, 1))

func _on_Countdown_timeout():
	ball.freeze = false
	countdown_label.text = "Go!"
	start_time = Time.get_ticks_msec()
	timer_player.start()
	await get_tree().create_timer(1.0).timeout
	countdown_label.hide()

func calculate_stars(time: float) -> int:
	if time <= three_star_time:
		return 3
	elif time <= two_star_time:
		return 2
	else:
		return 1

func round_to_decimals(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func save_score(time: float):
	leaderboard.append(time)
	leaderboard.sort()
	leaderboard = leaderboard.slice(0, 5)
	var file = FileAccess.open(leaderboard_file, FileAccess.WRITE)
	var json_data = JSON.stringify(leaderboard)
	file.store_string(json_data)
	file.close()

func load_leaderboard():
	if FileAccess.file_exists(leaderboard_file):
		var file = FileAccess.open(leaderboard_file, FileAccess.READ)
		var json_data = file.get_as_text()
		file.close()

		var json = JSON.new()
		var error = json.parse(json_data)  # Parse les données JSON

		if error == OK:
			leaderboard = json.get_data()  # Récupère les données parsées
		else:
			print("Erreur de parsing JSON :", error)
	else:
		leaderboard = []
