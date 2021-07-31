extends "res://addons/FracturalVNE/core/visuals/types/visual_controller_serializer.gd"
# Handles serialization for the SingleVisual class


func _get_controller_prefab_path():
	return "res://addons/FracturalVNE/core/visuals/types/single_visual/single_visual.tscn"


func _script_path():
	return "res://addons/FracturalVNE/core/visuals/types/single_visual/single_visual_controller.gd"
