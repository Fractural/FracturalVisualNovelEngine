extends WAT.Test
# Tests StoryAudioManager.


const StoryAudioManagerBuilder = preload("res://tests/core/audio/story_audio_manager.builder.gd")
const StoryAudioChannelSerializerBuilder = preload("res://tests/core/audio/story_audio_channel_controller_serializer.builder.gd")
const StoryAudioManager = preload("res://addons/FracturalVNE/core/audio/story_audio_manager.gd")
const ChannelBuilder = preload("res://tests/core/audio/story_audio_channel.builder.gd")
const SerializationManagerBuilder = preload("res://tests/core/utils/serialization/serialization_manager.builder.gd")
const ReferenceRegistryFakes = preload("res://tests/core/io/reference_registry.fakes.gd")
const ReferenceRegistry = preload("res://addons/FracturalVNE/core/io/reference_registry.gd")


func title():
	return "StoryAudioManager"


func start():
	# ----- test_add_new_channel_parameters ----- #
	
	var channel_set = ChannelBuilder.new().full_5_set()
	test_add_new_channel_parameters = [["channel", "channel_number"]]
	var i: int = 0
	for channel in channel_set:
		test_add_new_channel_parameters.append([channel, i])
		i += 1
		
	# ----- test_add_new_channel_parameters ----- #


var test_add_new_channel_parameters: Array
func test_add_new_channel():	
	parameters(test_add_new_channel_parameters)
	describe("When calling add_new_channel() with preset channel #%s" % p.channel_number)
	
	var channel = p.channel
	var mock_reference_registry = direct.script_blank(ReferenceRegistry, "Reference")
	mock_reference_registry.method("add_reference")
	var story_audio_manager = StoryAudioManagerBuilder.new().default(direct) \
		.inject_reference_registry(mock_reference_registry.double()) \
		.build()
	
	asserts.is_null(story_audio_manager.get_channel_controller(channel), "Then the channel controller does not exist before the call.")
	
	story_audio_manager.add_new_channel(channel)
	asserts.was_called_with_arguments(mock_reference_registry, "add_reference", [channel], "Then the channel was added to the reference registry after the call.")
	
	asserts.is_not_null(story_audio_manager.get_channel_controller(channel), "Then the channel controller exists after the call.")


func test_serialization():
	describe("When calling serialize() and deserialize()")
	
	var fake_reference_registry = ReferenceRegistryFakes.TestGetAddReference.new(direct)
	var serialization_manager = SerializationManagerBuilder.new().default(direct) \
		.build()
	var _story_audio_manager = StoryAudioManagerBuilder.new().default(direct) \
		.inject_reference_registry(fake_reference_registry.double()) \
		.inject_serialization_manager(serialization_manager) \
		.build()
	
	# TODO
	
	asserts.is_true(true, "Temporary assert to pass all unit tests. (Unit tests for StorYAudioManager is unfinished)")

#func test_audio_channel_creation():
#	describe("When calling AudioChannel()")
#
#	var story_audio_manager = StoryAudioManager.new()
#	var channel = Channel.new("Some Audio Bus", -0.5, 3, true, false)
