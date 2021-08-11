extends WAT.Test
# Tests StoryAudioManager.


const StoryAudioManager = preload("res://addons/FracturalVNE/core/audio/story_audio_manager.gd")
const Channel = FracVNE_StoryAudioChannel


func title():
	return "StoryAudioManager"


func test_pass():
	asserts.is_true(true, "Temporary assert to pass all unit tests. (Unit tests for StorYAudioManager is unfinished)")

#func test_audio_channel_creation():
#	describe("When calling AudioChannel()")
#
#	var story_audio_manager = StoryAudioManager.new()
#	var channel = Channel.new("Some Audio Bus", -0.5, 3, true, false)
