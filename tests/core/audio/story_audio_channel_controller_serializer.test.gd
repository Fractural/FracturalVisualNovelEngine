extends WAT.Test
# Tests the behaviour of a StoryAudioChannelSerializer.


const FracUtils = FracVNE.Utils
const Serializer = preload("res://addons/FracturalVNE/core/audio/story_audio_channel_controller_serializer.gd")
const ChannelControllerBuilder = preload("res://tests/core/audio/story_audio_channel_controller.builder.gd")
const SerializerBuilder = preload("res://tests/core/audio/story_audio_channel_controller_serializer.builder.gd")


func title():
	return "StoryAudioChannelControllerSerializer"


func test_serialization():
	describe("When serializing a controller")
	
	# ----- Test Setup ----- #
	
	var serializer_results = SerializerBuilder.new() \
		.dummy_story_director() \
		.fake_reference_registry() \
		.build() \
	
	var serializer = serializer_results.serializer
	var fake_reference_registry = serializer_results.reference_registry
	var dummy_story_director = serializer_results.story_director
	add_child(serializer)
	
	var controller_results = ChannelControllerBuilder.new() \
		.dummy_story_director() \
		.default_channel() \
		.build()
	
	var controller = controller_results.controller
	var channel = controller_results.channel
	add_child(controller)
	
	fake_reference_registry.add_reference(channel)
	
	# ----- Test Setup ----- #
	
	asserts.is_true(serializer.can_serialize(controller), "Then can serialize the controller.")
	var serialized_controller = serializer.serialize(controller)
	asserts.is_true(FracUtils.is_type(serialized_controller, "Dictionary"), "Then serialized controller is Dictionary.")
	
	asserts.is_true(serializer.can_deserialize(serialized_controller), "Then can deserialize the serialized controller.")
	var deserialized_controller = serializer.deserialize(serialized_controller)
	
	asserts.is_true(serializer.can_deserialize(serialized_controller), "Then can fetch dependencies for the serialized controller.")
	serializer.fetch_dependencies(deserialized_controller, serialized_controller)
	
	asserts.is_true(FracUtils.equals(controller, deserialized_controller), "Then deserialized controller == original controller.")
	serializer.free()
