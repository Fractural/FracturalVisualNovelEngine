extends WAT.Test
# Tests StoryAudioChannel.


const FracUtils = FracVNE.Utils
const Channel = FracVNE_StoryAudioChannel
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")

var channel: Channel


func title():
	return "StoryAudioChannel"


func start():
	channel = Channel.new("Master", 2, 2, true, true)


func test_serialization():
	describe("When calling serialize() and deserialize()")
	var serialized_channel = channel.serialize()
	asserts.is_true(FracUtils.is_type(serialized_channel, "Dictionary"), "Then serialized channel is Dictionary.")
	var deserialized_channel = SerializationUtils.deserialize(serialized_channel)
	asserts.is_true(FracUtils.equals(channel, deserialized_channel), "Then deserialized channel == original channel.")


func test_instantiation() -> void:
	describe("When calling instantiate_controller()")
	var mock_story_director = direct.script(StoryDirector)
	var controller = channel.instantiate_controller(mock_story_director.double())
	asserts.is_true(FracVNE.Utils.is_type(controller, "StoryAudioChannelController"), "The instantiated controller is an StoryAudioChannelController")
