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

func update_timer(time_left):
	$TimerLabel.text = str(floor(time_left))

func round_to_decimals(value: float, decimals: int) -> float:
	var factor = pow(10, decimals)
	return round(value * factor) / factor

func update_chronometer(time_elapsed):
	$ChronometerLabel.text = str(round_to_decimals(time_elapsed, 1))

func show_victory(stars, time_elapsed):
	$MidLabel.text = "Félicitations! Vous avez obtenu " + str(stars) + " étoiles!\nTemps: " + str(round_to_decimals(time_elapsed, 2)) + "s"
	$MidLabel.show()

func show_game_over(message):
	$MidLabel.text = message
	$MidLabel.show()
