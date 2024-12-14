extends PanelContainer

signal selectable_selected

@export var selectable_name = "":
	set = set_selectable

@export var selectable_model = "":
	set = set_selectable_model

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_selectable(value):
	selectable_name = value
	if not is_inside_tree():
		await ready

func set_selectable_model(value):
	selectable_model = value
	if not is_inside_tree():
		await ready

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		selectable_selected.emit(selectable_name, selectable_model)
		print("Selected ", selectable_name)
