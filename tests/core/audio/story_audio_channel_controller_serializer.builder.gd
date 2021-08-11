extends Reference
# Builds a StoryAudioChannelController for testing.


const FracUtils = FracVNE.Utils
const Serializer = preload("res://addons/FracturalVNE/core/audio/story_audio_channel_controller_serializer.gd")

var serializer
var story_director
var reference_registry


func build():
	assert(story_director != null, "Cannot build without a story_director.")
	assert(reference_registry != null, "Cannot build without a reference registry.")
	serializer = Serializer.new()
	serializer.story_director = story_director
	serializer.reference_registry = reference_registry
	return self


func dummy_story_director():
	story_director = DummyStoryDirector.new()
	return self


func dummy_reference_registry():
	reference_registry = DummyReferenceRegistry.new()
	return self


func fake_reference_registry():
	reference_registry = FakeReferenceRegistry.new()
	return self


class DummyStoryDirector extends Reference:
	pass


class FakeReferenceRegistry extends Reference:
	var references = []
	
	
	func add_reference(reference):
		if not references.has(reference):
			references.append(reference)
	
	
	func get_reference(id):
		return references[id]
	
	
	func get_reference_id(reference):
		return references.find(reference)


class DummyReferenceRegistry extends Reference:
	
	
	func get_reference(id):
		pass
	
	
	func get_reference_id(reference):
		pass
