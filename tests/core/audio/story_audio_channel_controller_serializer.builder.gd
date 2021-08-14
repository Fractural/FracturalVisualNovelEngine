extends Reference
# Builds a StoryAudioChannelController for testing.


const FracUtils = FracVNE.Utils
const Serializer = preload("res://addons/FracturalVNE/core/audio/story_audio_channel_controller_serializer.gd")
const ReferenceRegistry = preload("res://addons/FracturalVNE/core/io/reference_registry.gd")
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")

var story_director
var reference_registry

var serializer


func build():
	assert(story_director != null, "Cannot build without a story_director.")
	assert(reference_registry != null, "Cannot build without a reference registry.")
	serializer = Serializer.new()
	serializer.story_director = story_director
	serializer.reference_registry = reference_registry
	return serializer


func inject_story_director(story_director_):
	FracUtils.try_free(story_director)
	story_director = story_director_
	return self


func inject_reference_registry(reference_registry_):
	FracUtils.try_free(reference_registry)
	reference_registry = reference_registry_
	return self


func default(direct):
	inject_story_director(direct.script_blank(StoryDirector, "Reference").double())
	inject_reference_registry(direct.script_blank(ReferenceRegistry, "Reference").double())
	return self
