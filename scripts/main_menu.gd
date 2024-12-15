extends Control

func _ready():
	# Connecter les boutons avec Callable
	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(Callable(self, "_on_play_pressed"))
	$CenterContainer/VBoxContainer/OptionsButton.pressed.connect(Callable(self, "_on_options_pressed"))
	$CenterContainer/VBoxContainer/QuitButton.pressed.connect(Callable(self, "_on_quit_pressed"))

func _on_play_pressed():
	# Charger la scène de sélection des niveaux
	get_tree().change_scene_to_file("res://scenes/LevelSelector.tscn")

func _on_options_pressed():
	# Charger la scène des options
	get_tree().change_scene_to_file("res://scenes/menu/OptionsPopup.tscn")

func _on_quit_pressed():
	# Quitter le jeu
	get_tree().quit()
