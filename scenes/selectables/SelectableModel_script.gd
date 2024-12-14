extends Node3D

# Récupère le nœud contenant le modèle importé
@export_node_path var model_path:
	set = set_model_path

const SELECTABLES_LAYER_INDEX = 4;

func set_model_path(value):
	model_path = value
	if not is_inside_tree():
		await ready

func find_static_body(node: Node) -> StaticBody3D:
	if node.is_class("StaticBody3D"):
		return node
	for child in node.get_children():
		var result = find_static_body(child)
		if result:
			return result
	return null  # Retourne null si aucun StaticBody3D n'est trouvé

func disable_model():
	var model_instance = get_node(model_path)
	if model_instance:
		var static_body = find_static_body(model_instance)
		if static_body:
			static_body.set_collision_layer_value(SELECTABLES_LAYER_INDEX, false)
			static_body.set_collision_mask_value(1, false)

func enable_model():
	var model_instance = get_node(model_path)
	if model_instance:
		var static_body = find_static_body(model_instance)
		if static_body:
			static_body.set_collision_layer_value(SELECTABLES_LAYER_INDEX, true)
			static_body.set_collision_mask_value(1, true)