extends Node
# Handles serialization for the Visual class


export var story_director_path: NodePath

onready var story_director = get_node(story_director_path)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	return {
		"script_path": _script_path(),
		"visible": object.visible,
		"global_position": SerializationUtils.serialize_vec2(object.global_position),
	}


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var visual_prefab = load("res://addons/FracturalVNE/core/visuals/types/single_visual/single_visual.tscn")
	
	var instance = visual_prefab.instance()
	
	instance.init_(story_director)
	instance.visible = serialized_object["visible"]
	instance.global_position = SerializationUtils.deserialize_vec2(serialized_object["global_position"])
	
	return instance


func _script_path():
	return "res://addons/FracturalVNE/core/visuals/types/visual.gd"
