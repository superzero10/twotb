extends Control

const CONFIG_PATH = "user://settings.cfg"
var config = ConfigFile.new()

@onready var option_button = $VBoxContainer/resolution/OptionButton
@onready var fullscreen_checkbox = $VBoxContainer/fullscreen/CheckBox
@onready var volume_slider = $VBoxContainer/volume/HSlider
@onready var return_button = $VBoxContainer/return

# List of supported resolutions
var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
]

func _ready():
	ensure_config_file_exists()
	load_settings()
	populate_resolutions()
	return_button.connect("pressed", Callable(self, "_on_ReturnButton_pressed"))

func ensure_config_file_exists():
	if not FileAccess.file_exists(CONFIG_PATH):
		save_settings()
		print("Settings file created: ", CONFIG_PATH)

func populate_resolutions():
	option_button.clear()
	for res in resolutions:
		option_button.add_item("%d x %d" % [res.x, res.y])
	
	# Set current resolution in the menu
	var width = config.get_value("graphics", "width", 1280)
	var height = config.get_value("graphics", "height", 720)
	var current_res = Vector2i(width, height)
	var res_index = resolutions.find(current_res)
	if res_index != -1:
		option_button.select(res_index)

func _on_OptionButton_item_selected(index):
	var resolution = resolutions[index]
	DisplayServer.window_set_size(resolution)
	save_settings_with_resolution(resolution)

func _on_CheckBox_toggled(button_pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	save_settings()

func _on_ReturnButton_pressed():
	save_settings() # Save settings before leaving
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func load_settings():
	var err = config.load(CONFIG_PATH)
	if err != OK:
		print("No settings file found, creating defaults")
		save_settings()
		return
	
	# Load resolution
	var width = config.get_value("graphics", "width", 1280)
	var height = config.get_value("graphics", "height", 720)
	DisplayServer.window_set_size(Vector2i(width, height))
	
	# Load fullscreen
	var fullscreen = config.get_value("graphics", "fullscreen", false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_checkbox.button_pressed = fullscreen

	# Load volume
	var volume = config.get_value("audio", "volume", 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
	volume_slider.value = volume

	# Immediately apply settings
	apply_settings()

func save_settings_with_resolution(resolution):
	# Save resolution
	config.set_value("graphics", "width", resolution.x)
	config.set_value("graphics", "height", resolution.y)
	save_settings()

func save_settings():
	# Save resolution
	var resolution = DisplayServer.window_get_size()
	config.set_value("graphics", "width", resolution.x)
	config.set_value("graphics", "height", resolution.y)

	# Save fullscreen
	config.set_value("graphics", "fullscreen", fullscreen_checkbox.button_pressed)
	
	# Save volume
	var volume = volume_slider.value
	config.set_value("audio", "volume", volume)
	
	# Save to file
	config.save(CONFIG_PATH)

func apply_settings():
	var width = config.get_value("graphics", "width", 1280)
	var height = config.get_value("graphics", "height", 720)
	DisplayServer.window_set_size(Vector2i(width, height))

	var fullscreen = config.get_value("graphics", "fullscreen", false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

	var volume = config.get_value("audio", "volume", 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
	volume_slider.value = volume
