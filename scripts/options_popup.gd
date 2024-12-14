extends Control

func _ready():
	# Connecter le bouton retour
	$CenterContainer/VBoxContainer/return.pressed.connect(Callable(self, "_on_return_pressed"))

	# Connecter les options
	$CenterContainer/VBoxContainer/fullscreen/CheckBox.toggled.connect(Callable(self, "_on_fullscreen_toggled"))
	$CenterContainer/VBoxContainer/resolution/OptionButton.item_selected.connect(Callable(self, "_on_resolution_selected"))
	$CenterContainer/VBoxContainer/volume/HSlider.value_changed.connect(Callable(self, "_on_volume_changed"))

func _on_fullscreen_toggled(value: bool):
	if value:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index: int):
	match index:
		0:
			DisplayServer.window_set_size(Vector2(1280, 720))
		1:
			DisplayServer.window_set_size(Vector2(1920, 1080))

func _on_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value * -80)

func _on_return_pressed():
	# Revenir au menu principal
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
