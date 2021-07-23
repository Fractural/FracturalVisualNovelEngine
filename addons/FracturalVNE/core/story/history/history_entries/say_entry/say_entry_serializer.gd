extends Node


export var reference_registry_path: NodePath

onready var reference_registry = get_node(reference_registry_path)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	var serialized_object = {
		"script_path": _script_path(),
		"text": object.text,
	}
	
	if object.character != null and typeof(object.character) != TYPE_STRING:
		serialized_object["character_id"] = reference_registry.get_reference_id(object.character)
	else:
		serialized_object["character_name"] = object.character
	
	return serialized_object


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = load(_script_path()).new()
	
	instance.text = serialized_object["text"]
	
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	if serialized_object.has("character_id"):
		instance.character = reference_registry.get_reference(serialized_object["character_id"])
	else:
		instance.character = serialized_object["character_name"]


func _script_path():
	return "res://addons/FracturalVNE/core/story/history/history_entries/say_entry/say_entry.gd"
