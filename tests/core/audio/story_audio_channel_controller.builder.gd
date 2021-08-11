extends Reference
# Builds a StoryAudioChannelController for testing.


const CONTROLLER_PREFAB = preload("res://addons/FracturalVNE/core/audio/story_audio_channel.tscn")
const Channel = FracVNE_StoryAudioChannel

var controller
var channel
var story_director


func build():
	assert(channel != null, "Cannot build controller without a channel.")
	assert(story_director != null, "Cannot build controller without a story director.")
	controller = CONTROLLER_PREFAB.instance()
	controller.init(channel, story_director)
	return self


func default_channel():
	channel = Channel.new()
	return self


func skippable_channel():
	channel = Channel.new("Master", 1, 1, true, true)
	return self


func unskippable_channel():
	channel = Channel.new("Master", 1, 1, true, false)
	return self


func dummy_story_director():
	story_director = DummyStoryDirector.new()
	return self


func spy_story_director():
	story_director = SpyStoryDirector.new()
	return self


func fake_story_director():
	story_director = FakeStoryDirector.new()
	return self


class DummyStoryDirector extends Reference:
	pass


class SpyStoryDirector extends Reference:
	var add_step_action_call_count: int = 0
	var remove_step_action_call_count: int = 0
	
	
	func add_step_action(step_action):
		add_step_action_call_count += 1
	
	
	func remove_step_action(step_action):
		remove_step_action_call_count += 1


class FakeStoryDirector extends Reference:
	var step_actions: Array = []
	
	
	func _t__skip_all_step_actions():
		for step_action in step_actions:
			step_action.skip()
		step_actions.clear()
	
	
	func add_step_action(step_action):
		step_actions.append(step_action)
	
	
	func remove_step_action(step_action):
		step_actions.erase(step_action)
