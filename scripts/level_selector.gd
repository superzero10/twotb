extends Control

const LEVEL_SCENES = [
	"res://Levels/Level1.tscn",
	"res://Levels/Level2.tscn",
	"res://Levels/Level3.tscn",
	"res://Levels/Level4.tscn",
	"res://Levels/Level5.tscn",
	"res://Levels/Level6.tscn"
]

func _ready():
	# Connecter les boutons de niveaux
	for i in range(6):
		var button = $CenterContainer/VBoxContainer/GridContainer.get_child(i)
		button.text = "Niveau " + str(i + 1)
		button.pressed.connect(Callable(self, "_on_level_selected").bind(i))

	# Connecter le bouton retour
	$CenterContainer/VBoxContainer/GridContainer/ButtonReturn.pressed.connect(Callable(self, "_on_return_pressed"))

func _on_level_selected(level_index: int):
	# Charger la scène du niveau sélectionné
	get_tree().change_scene_to_file(LEVEL_SCENES[level_index])

func _on_return_pressed():
	# Revenir au menu principal
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
