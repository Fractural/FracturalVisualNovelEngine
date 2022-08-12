extends Reference
# Builds a StoryAudioChannelController for testing.


const FracUtils = FracVNE.Utils
const CONTROLLER_PREFAB = preload("res://addons/FracturalVNE/core/audio/story_audio_channel.tscn")
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")
const AudioChannel = preload("res://addons/FracturalVNE/core/audio/story_audio_channel.gd")

var channel
var story_director

var controller


func build():
	assert(channel != null, "Cannot build controller without a channel.")
	assert(story_director != null, "Cannot build controller without a story director.")
	controller = CONTROLLER_PREFAB.instance()
	controller.init(channel, story_director)
	return controller


func inject_story_director(story_director_):
	FracUtils.try_free(story_director)
	story_director = story_director_
	return self


func inject_channel(channel_):
	FracUtils.try_free(channel)
	channel = channel_
	return self


func default(direct):
	inject_story_director(direct.script(StoryDirector).double())
	inject_channel(direct.script(AudioChannel).double())
	return self
