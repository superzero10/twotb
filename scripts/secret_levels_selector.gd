extends Control

const SECRET_LEVEL_SCENES = [
	"res://scenes/levels/levelM1.tscn",
	"res://scenes/levels/levelM2.tscn",
	"res://scenes/levels/levelM3.tscn",
	"res://scenes/levels/levelM4.tscn",
	"res://scenes/levels/levelM5.tscn",
	"res://scenes/levels/levelM6.tscn"
]

@onready var grid_container = $CenterContainer/GridContainer

func _ready():
	# Connecter les boutons de niveaux
	for i in range(6):
		var button = grid_container.get_child(i)
		button.text = "Niveau " + str(i + 1)
		button.pressed.connect(_on_level_selected.bind(i))

func _on_level_selected(level_index: int):
	# Charger la scène du niveau sélectionné
	get_tree().change_scene_to_file(SECRET_LEVEL_SCENES[level_index])

func _on_return_pressed():
	# Revenir au menu principal
	get_tree().change_scene_to_file("res://scenes/menu/LevelSelector.tscn")
