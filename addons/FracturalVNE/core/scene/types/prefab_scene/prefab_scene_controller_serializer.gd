extends "res://addons/FracturalVNE/core/scene/types/scene_controller_serializer.gd"
# Handles serialization for PrefabSceneController.


func _get_controller_prefab():
	return preload("prefab_scene.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/prefab_scene_controller.gd"
