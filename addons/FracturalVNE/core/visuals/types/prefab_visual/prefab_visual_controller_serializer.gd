extends "res://addons/FracturalVNE/core/visuals/types/visual_controller_serializer.gd"
# Handles serialization for the PrefabVisual class


func _get_controller_prefab_path():
	return "res://addons/FracturalVNE/core/visuals/types/prefab_visual/prefab_visual.tscn"


func _script_path():
	return "res://addons/FracturalVNE/core/visuals/types/prefab_visual/prefab_visual_controller.gd"
