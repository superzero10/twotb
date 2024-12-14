extends PanelContainer

signal selectable_model_selected

func _on_selectable_selected(selectable_name, selectable_model):
	print("Next selected is : " + selectable_name)
	selectable_model_selected.emit(selectable_model)
