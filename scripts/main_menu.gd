extends Control

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
