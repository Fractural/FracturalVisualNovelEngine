extends "res://addons/FracturalVNE/core/visuals/types/visual_controller_serializer.gd"
# Handles serialization for the MultiVisualController class


func serialize(object):
	var serialized_object = .serialize(object)
	serialized_object["curr_texture_path"] = object.sprite.texture.get_path()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.sprite.texture = load(serialized_object["curr_texture_path"])
	return instance


func _get_controller_prefab():
	return preload("multi_visual.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/multi_visual_controller.gd"
