extends Node
# -- Abstract Class -- #
# Handles serialization for the StoryAudioChannelController class


export var story_director_path: NodePath
export var reference_registry_path: NodePath

onready var story_director = get_node(story_director_path)
onready var reference_registry = get_node(reference_registry_path)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	var obj = {
		"script_path": _script_path(),
		"parent_path": object.get_parent().get_path(),
		"channel_id": reference_registry.get_reference_id(object.channel),
	}
	return obj


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = _get_controller_prefab().instance()
	get_node(serialized_object["parent_path"]).add_child(instance)
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	var channel = reference_registry.get_reference(serialized_object["channel_id"])
	instance.init(channel, story_director)


func _get_controller_prefab():
	return preload("story_audio_channel.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/story_audio_channel_controller.gd"
