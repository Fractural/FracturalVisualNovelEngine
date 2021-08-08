extends WAT.Test


var channel: FracVNE_StoryAudioChannel


func title():
	return "Given a StoryAudioChannel"


func start():
	channel = FracVNE_StoryAudioChannel.new("Master", 2, 2, true, true)

func test_serialization():
	describe("When calling serialize() and deserialize()")
	var serialized_channel = channel.serialize()
	
	asserts.is_true(FracVNE.Utils.is_type(serialized_channel, "Dictionary"), "Then the serialized channel is a Dictionary.")
	
	var deserialized_channel = SerializationUtils.deserialize(serialized_channel)
	
	asserts.is_true(FracVNE.Utils.is_type(deserialized_channel, "StoryAudioChannel"), "Then the deserialized channel is a StoryAudioChannel.")
	asserts.is_true(deserialized_channel.audio_bus == channel.audio_bus, "channel"), "Then the deserialized channel has the same audio bus.")
	


func _confirm_serialization_of_property(object, deserialized_object, variable_name: String):
	asserts.is_true(deserialized_channel. == channel.volume_db, "Then the deserialized channel has the same \"%s\"." % variable_name 


func test_instantiation() -> void:
	describe("When calling instantiate_controller()")
	var channel = Fakechannel.new(true)
	var controller = channel.instantiate_controller(MockStoryDirector.new())
	asserts.is_true(FracVNE.Utils.is_type(controller, "channelController"), "The instantiated controller is an channelController")


class MockStoryDirector extends Reference:
	func _init():
		pass
