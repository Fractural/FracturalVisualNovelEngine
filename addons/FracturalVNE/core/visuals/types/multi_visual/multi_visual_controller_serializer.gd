extends "res://addons/FracturalVNE/core/visuals/types/visual_controller_serializer.gd"
# Handles serialization for the MultiVisualController class


func serialize(object):
	var serialized_object = .serialize(object)
	serialized_object["texture"] = object.sprite.texture


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.sprite.texture = serialized_object["texture"]


func _get_controller_prefab_path():
	return "res://addons/FracturalVNE/core/visuals/types/multi_visual/multi_visual.tscn"


func _script_path():
	return "res://addons/FracturalVNE/core/visuals/types/multi_visual/multi_visual_controller.gd"

