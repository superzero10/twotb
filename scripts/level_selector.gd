extends Control

const LEVEL_SCENES = [
	"res://scenes/levels/level1.tscn",
	"res://scenes/levels/level2.tscn",
	"res://scenes/levels/level3.tscn",
	"res://scenes/levels/level4.tscn"
]

const SECRET_CODE_KEYS = ["2","0", "2","3","1","9","6","8"]

@onready var grid_container = $CenterContainer/GridContainer
@onready var secret_levels_button = $SecretLevelsButton

var secret_code_idx = 0

func _ready():
	# Connecter les boutons de niveaux
	for i in range(6):
		var button = grid_container.get_child(i)
		button.text = "Niveau " + str(i + 1)
		button.pressed.connect(Callable(self, "_on_level_selected").bind(i))

func _input(event):
	if Global.SecretsLevelsUnlocked == false and event is InputEventKey and event.pressed:
		var char = char(event.unicode)
		print("Chiffre appuyé :", char)
		if char.is_valid_int() and char == SECRET_CODE_KEYS[secret_code_idx]:
			secret_code_idx += 1
			if secret_code_idx == SECRET_CODE_KEYS.size():
				unlock_secret_levels()

func unlock_secret_levels():
	Global.SecretsLevelsUnlocked = true
	secret_levels_button.set_visible(true);
	print("Niveaux secrets débloqués !")
	pass

func _on_level_selected(level_index: int):
	# Charger la scène du niveau sélectionné
	get_tree().change_scene_to_file(LEVEL_SCENES[level_index])

func _on_return_pressed():
	# Revenir au menu principal
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_secret_levels_button_pressed():
	if Global.SecretsLevelsUnlocked == false:
		return
	get_tree().change_scene_to_file("res://scenes/menu/SecretLevelsSelector.tscn")
