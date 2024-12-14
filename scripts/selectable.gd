extends PanelContainer

signal selectable_selected

@export var selectable_name = "":
	set = set_selectable

@export var selectable_model: PackedScene:
	set = set_selectable_model

func set_selectable(value):
	selectable_name = value
	if not is_inside_tree():
		await ready

func set_selectable_model(value):
	selectable_model = value
	if not is_inside_tree():
		await ready

func _on_button_pressed():
	selectable_selected.emit(selectable_name, selectable_model)
