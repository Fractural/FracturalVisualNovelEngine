extends Reference
# Builds a StoryAudioChannelController for testing.


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
	story_director = story_director_
	return self


func inject_channel(channel_):
	channel = channel_
	return self


func default(direct):
	channel = direct.script_blank(AudioChannel, "Reference").double()
	story_director = direct.script_blank(StoryDirector, "Reference").double()
	return self
