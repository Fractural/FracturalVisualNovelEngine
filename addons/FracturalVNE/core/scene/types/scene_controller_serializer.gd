extends Node
# Handles serialization for SceneController.


export var reference_registry_path: NodePath

onready var reference_registry = get_node(reference_registry_path)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	return {
		"script_path": _script_path(),
		"scene_id": reference_registry.get_reference_id(object.scene),
	}


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = load(_script_path()).new()
	
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	instance.scene = serialized_object["scene_id"]


func _script_path():
	return "res://addons/FracturalVNE/core/scene/types/scene_controller.gd"
