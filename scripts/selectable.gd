extends PanelContainer

signal selectable_selected

@export var selectable_name = "":
	set = set_selectable

@export var selectable_model: PackedScene:
	set = set_selectable_model

# Export d'une variable pour stocker une touche de clavier
@export var action_name: String = ""

func set_selectable(value):
	selectable_name = value
	if not is_inside_tree():
		await ready

func set_selectable_model(value):
	selectable_model = value
	if not is_inside_tree():
		await ready

func select_me():
	selectable_selected.emit(selectable_name, selectable_model)

func _on_button_pressed():
	select_me()

func _input(event):
	if is_visible_in_tree() and InputMap.has_action(action_name) and event.is_action_pressed(action_name):
		select_me()
