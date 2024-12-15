extends Control

@onready var audio_player_tap = $AudioStreamPlayer

func resumePlay():
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.GameHasPaused = false
	set_visible(false)
	get_tree().paused = false

func _on_resume_button_pressed():
	resumePlay()

func _on_main_menu_button_pressed():
	resumePlay()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_quit_button_pressed():
	Global.GameHasPaused = false
	get_tree().quit()

func _on_mouse_entered():
	audio_player_tap.play()
