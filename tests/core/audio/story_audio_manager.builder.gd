extends Node
# Builds a StoryAudioManager for testing.


const StoryAudioManager = preload("res://addons/FracturalVNE/core/audio/story_audio_manager.gd")


var channels_holder
var story_director
var reference_registry
var serialization_manager
var story_audio_manager


func build():
	assert(channels_holder != null)
	assert(story_director != null)
	assert(reference_registry != null)
	assert(serialization_manager != null)
	story_audio_manager = StoryAudioManager.new()
	story_audio_manager.channels_holder = channels_holder
	story_audio_manager.add_child(channels_holder)
	story_audio_manager.reference_registry = reference_registry
	story_audio_manager.serialization_manager = serialization_manager
	return self


func dummy_channels_holder():
	channels_holder = DummyChannelsHolder.new()
	return self


func dummy_reference_registry():
	reference_registry = DummyReferenceRegistry.new()
	return self


class DummyChannelsHolder extends Node:
	pass


class DummyReferenceRegistry extends Reference:
	
	func add_reference(reference):
		pass
	
	
	func get_reference(id):
		pass
	
	
	func get_reference_id(reference):
		pass	
