extends "res://addons/FracturalVNE/core/actor/actor_controller_serializer.gd"
# Handles serialization for SceneController.


func _script_path():
	return get_script().get_path().get_base_dir() + "/scene_controller.gd"
