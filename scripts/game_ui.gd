extends PanelContainer

@onready var selectables = $VBoxContainer

signal selectable_model_selected

func _on_selectables_selectable_model_selected(selectable_model):
	selectable_model_selected.emit(selectable_model)

func set_selectables_visiblity(visible: bool):
	selectables.visible = visible
