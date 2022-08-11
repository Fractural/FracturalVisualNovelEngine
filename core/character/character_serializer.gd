extends Node
# Handles serialization for the Character class


export var reference_registry_path: NodePath

onready var reference_registry = get_node(reference_registry_path)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	return {
		"script_path": _script_path(),
		"name": object.name,
		"name_color": object.name_color.to_html(),
		"dialogue_color": object.dialogue_color.to_html(),
		"visual_id": reference_registry.get_reference_id(object.visual)
	}


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = load(_script_path()).new()
	instance.name = serialized_object["name"]
	instance.name_color = Color(serialized_object["name_color"])
	instance.dialogue_color = Color(serialized_object["dialogue_color"])
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	if serialized_object["visual_id"] > -1:
		instance.visual = reference_registry.get_reference(serialized_object["visual_id"])


func _script_path():
	return get_script().get_path().get_base_dir() + "/character.gd"
