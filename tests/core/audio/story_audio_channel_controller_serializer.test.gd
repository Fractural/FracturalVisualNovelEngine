extends WAT.Test
# Tests a StoryAudioChannelSerializer.


const FracUtils = FracVNE.Utils
const Serializer = preload("res://addons/FracturalVNE/core/audio/story_audio_channel_controller_serializer.gd")
const ChannelBuilder = preload("res://tests/core/audio/story_audio_channel.builder.gd")
const ChannelControllerBuilder = preload("res://tests/core/audio/story_audio_channel_controller.builder.gd")
const SerializerBuilder = preload("res://tests/core/audio/story_audio_channel_controller_serializer.builder.gd")
const ReferenceRegistryFakes = preload("res://tests/core/io/reference_registry.fakes.gd")


func title():
	return "StoryAudioChannelControllerSerializer"


func test_serialization():
	describe("When calling serialize() and deserialize()")
	
	# ----- Test Setup ----- #
	
	var fake_reference_registry = ReferenceRegistryFakes.TestGetAddReference.new(direct)
	var serializer = SerializerBuilder.new().default(direct) \
		.inject_reference_registry(fake_reference_registry.double()) \
		.build()
	add_child(serializer)
	
	var channel = ChannelBuilder.new().default(direct).build()
	var controller = ChannelControllerBuilder.new().default(direct) \
		.inject_channel(channel) \
		.build()
	add_child(controller)
	
	fake_reference_registry.double().add_reference(channel)
	
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
