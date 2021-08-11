extends Reference
# Builds a StoryAudioChannelController for testing.


const CONTROLLER_PREFAB = preload("res://addons/FracturalVNE/core/audio/story_audio_channel.tscn")
const Channel = FracVNE_StoryAudioChannel
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")

var controller
var channel
var story_director


func build():
	assert(channel != null, "Cannot build controller without a channel.")
	assert(story_director != null, "Cannot build controller without a story director.")
	controller = CONTROLLER_PREFAB.instance()
	controller.init(channel, story_director)
	return self


func free():
	if controller != null:
		controller.free()


func inject_story_director(story_director_):
	story_director = story_director_
	return self


func inject_channel(channel_):
	channel = channel_
	return self


# ----- Presets ----- #

func default_channel():
	channel = Channel.new()
	return self


func skippable_channel():
	channel = Channel.new("Master", 1, 1, true, true)
	return self


func unskippable_channel():
	channel = Channel.new("Master", 1, 1, true, false)
	return self


func fake_story_director(direct):
	story_director = FakeStoryDirector.new(direct)
	return self

# ----- Presets ----- #


class FakeStoryDirector extends WAT.FakeMock:
	var step_actions: Array = []
	
	
	func _init(direct).(direct, StoryDirector):
		_bind_mock_function("add_step_action")
		_bind_mock_function("remove_step_action")
	
	
	func skip_all_step_actions():
		for step_action in step_actions:
			step_action.skip()
		step_actions.clear()
	
	
	func add_step_action(object, args: Array):
		step_actions.append(args[0])
	
	
	func remove_step_action(object, args: Array):
		step_actions.erase(args[0])
