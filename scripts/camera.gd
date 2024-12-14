extends Node3D

# Signal pour permettre au Sélecteur de modèle de se mettre à jour
signal slow_motion_toggled

# Récupère le signal émit par l'enfant "CameraControl" pour le ré-émettre aux autres Nodes
func _on_camera_control_slow_motion_toggled(toggled: bool):
	slow_motion_toggled.emit(toggled)
