extends "res://addons/FracturalVNE/core/visuals/types/visual_controller_serializer.gd"
# Handles serialization for the PrefabVisual class


func _get_controller_prefab():
	return preload("prefab_visual.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/prefab_visual_controller.gd"
