extends Node
# Builds a StoryAudioManager for testing.


const StoryAudioManager = preload("res://addons/FracturalVNE/core/audio/story_audio_manager.gd")
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")
const ReferenceRegistry = preload("res://addons/FracturalVNE/core/io/reference_registry.gd")
const SerializationManager = preload("res://addons/FracturalVNE/core/utils/serialization/serialization_manager.gd")

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
	if channels_holder.get_parent() == null:
		story_audio_manager.add_child(channels_holder)
	story_audio_manager.reference_registry = reference_registry
	story_audio_manager.serialization_manager = serialization_manager
	return story_audio_manager


func inject_channels_holder(channels_holder_):
	channels_holder = channels_holder_
	return self


func inject_reference_registry(reference_registry_):
	reference_registry = reference_registry_
	return self


func inject_serialization_manager(serialization_manager_):
	serialization_manager = serialization_manager_
	return self


func inject_story_audio_manager(story_audio_manager_):
	story_audio_manager = story_audio_manager_
	return self


func default(direct):
	channels_holder = Node.new()
	story_director = direct.script_blank(StoryDirector, "Reference").double()
	reference_registry = direct.script_blank(ReferenceRegistry, "Reference").double()
	serialization_manager = direct.script_blank(SerializationManager, "Reference").double()
	return self
