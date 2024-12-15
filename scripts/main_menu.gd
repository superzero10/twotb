extends Control

const CONFIG_PATH = "user://settings.cfg"
var config = ConfigFile.new()

@onready var audio_player_tap = $AudioPlayer_tap
@onready var audio_player_select = $AudioPlayer_select

func _on_play_pressed():
	audio_player_select.play()
	# Charger la scène de sélection des niveaux
	get_tree().change_scene_to_file("res://scenes/menu/LevelSelector.tscn")

func _on_options_pressed():
	audio_player_select.play()
	# Charger la scène des options
	get_tree().change_scene_to_file("res://scenes/menu/OptionsPopup.tscn")

func _on_quit_pressed():
	audio_player_select.play()
	# Quitter le jeu
	get_tree().quit()


func _on_mouse_entered():
	audio_player_tap.play()

func _ready():
	load_settings()

func load_settings():
	var err = config.load(CONFIG_PATH)
	if err != OK:
		print("No settings file found, creating defaults")
		return
	
	# Charger la résolution
	var width = config.get_value("graphics", "width", 1280)
	var height = config.get_value("graphics", "height", 720)
	DisplayServer.window_set_size(Vector2i(width, height))
	
	# Charger le mode plein écran
	var fullscreen = config.get_value("graphics", "fullscreen", false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Charger le volume
	var volume = config.get_value("audio", "volume", 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
