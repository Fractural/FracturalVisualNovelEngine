extends Node
# Handles serialization for the MultiVisual class


export var story_director_path: NodePath

onready var story_director = get_node(story_director_path)



func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	var texture_paths = []
	
	var current_texture_index = -1
	var i = 0
	for texture in object.textures:
		if object.sprite.texture == texture:
			current_texture_index = i
		texture_paths.append(texture.get_path())
		i += 1
	
	var obj = {
		"script_path": _script_path(),
		"name": object.name,
		"texture_paths": texture_paths,
		"current_texture_id": current_texture_index,
		"visible": object.visible,
		"global_position": SerializationUtils.serialize_vec2(object.global_position),
	}
	return obj


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var visual_prefab = load("res://addons/FracturalVNE/core/visuals/types/multi_visual/multi_visual.tscn")
	
	var instance = visual_prefab.instance()
	
	var textures = []
	for texture_path in serialized_object["texture_paths"]:
		textures.append(load(texture_path))
	
	instance.init_(story_director, textures)
	
	if serialized_object["current_texture_id"] > -1:
		instance.sprite.texture = textures[serialized_object["current_texture_id"]]
	
	instance.visible = serialized_object["visible"]
	instance.global_position = SerializationUtils.deserialize_vec2(serialized_object["global_position"])
	
	return instance


func _script_path():
	return "res://addons/FracturalVNE/core/visuals/types/multi_visual/multi_visual.gd"

