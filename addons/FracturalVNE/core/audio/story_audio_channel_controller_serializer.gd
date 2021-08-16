extends Node
# -- Abstract Class -- #
# Handles serialization for the StoryAudioChannelController class

# TODO: Add serialization for hte position of the playhead for
#		the current playing sound.


const FracUtils = FracVNE.Utils

export var story_director_path: NodePath
export var reference_registry_path: NodePath

onready var story_director = FracUtils.get_valid_node_or_dep(self, story_director_path, story_director)
onready var reference_registry = FracUtils.get_valid_node_or_dep(self, reference_registry_path, reference_registry)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	var queued_sound_paths = []
	for sound in object.sound_queue:
		queued_sound_paths.append(sound.get_path())
	
	var serialized_object = {
		"script_path": _script_path(),
		"parent_path": object.get_parent().get_path(),
		"story_audio_channel_id": reference_registry.get_reference_id(object.story_audio_channel),
		"queued_sound_paths": queued_sound_paths,
	}
	
	if object.get_current_sound() != null:
		serialized_object["current_sound_path"] = object.get_current_sound().get_path()
	
	return serialized_object


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = _get_controller_prefab().instance()
	get_node(serialized_object["parent_path"]).add_child(instance)
	var queued_sounds = []
	for sound_id in serialized_object["queued_sound_paths"]:
		queued_sounds.append(reference_registry.get_reference(sound_id))
	instance.sound_queue = queued_sounds
	
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	var story_audio_channel = reference_registry.get_reference(serialized_object["story_audio_channel_id"])
	instance.init(story_audio_channel, story_director)
	
	# StoryAudioChannelControllers can only play a sound after they have been initialized.
	if serialized_object.has("current_sound_path"):
		instance.play(load(serialized_object["current_sound_path"]))


func _get_controller_prefab():
	return preload("story_audio_channel.tscn")


func _script_path():
	return get_script().get_path().get_base_dir() + "/story_audio_channel_controller.gd"
