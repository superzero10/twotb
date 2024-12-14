extends PanelContainer

@onready var selectables = $VBoxContainer

@export var camera: Node:
	set = set_camera_reference

@export var draggable_manager: Node:
	set = set_draggable_manager

signal selectable_model_selected

func set_camera_reference(value):
	camera = value
	if not is_inside_tree():
		await ready

func set_draggable_manager(value):
	draggable_manager = value
	if not is_inside_tree():
		await ready

func _ready():
	# Si le joueur appuie sur "Alt", la Caméra va émettre le signal "slow_motion_toggled" avec true/false
	# On peut récupérer la valeur ici pour afficher ou non le menu
	camera.connect("slow_motion_toggled", set_selectables_visiblity)

func _on_selectables_selectable_model_selected(selectable_model):
	selectable_model_selected.emit(selectable_model)

func set_selectables_visiblity(visible: bool):
	selectables.visible = visible
	if visible == false:
		draggable_manager.cancel_dragging()
