extends Control

func _on_play_pressed():
	# Charger la scène de sélection des niveaux
	get_tree().change_scene_to_file("res://scenes/menu/LevelSelector.tscn")

func _on_options_pressed():
	# Charger la scène des options
	get_tree().change_scene_to_file("res://scenes/menu/OptionsPopup.tscn")

func _on_quit_pressed():
	# Quitter le jeu
	get_tree().quit()
