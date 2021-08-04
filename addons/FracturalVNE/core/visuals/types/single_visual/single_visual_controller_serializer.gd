extends "res://addons/FracturalVNE/core/visuals/types/visual_controller_serializer.gd"
# Handles serialization for the SingleVisual class


func _get_controller_prefab():
	return preload("single_visual.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/single_visual_controller.gd"
