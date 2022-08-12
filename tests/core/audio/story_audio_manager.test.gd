extends WAT.Test
# Tests StoryAudioManager.


const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils

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
	test_add_new_channel_parameters = _generate_channel_params()
	test_audio_channel_creation_parameters = _generate_channel_params()
	test_audio_channel_creation_error_handling_parameters = [
		["audio_bus", "volume_db", "pitch_scale", "queue_by_default", "is_skippable"],
		[1234, 3, 1.5, false, true],			# Invalid audio_bus
		["Master", false, 1.5, false, true],	# Invalid volume_db
		["Master", 3, "test", false, true],		# Invalid pitch_scale
		["Master", 3, 1.5, "test asdf", true],	# Invalid queue_by_default
		["Master", 3, 1.5, false, 234],			# Invalid is_skippable
	]


func _generate_channel_params():
	var channel_set = ChannelBuilder.new().full_5_set()
	var params = [["channel", "channel_number"]]
	var i: int = 0
	for channel in channel_set:
		params.append([channel, i])
		i += 1
	return params


var test_add_new_channel_parameters: Array
func test_add_new_channel():
	parameters(test_add_new_channel_parameters)
	describe("When calling add_new_channel() with preset channel #%s" % p.channel_number)
	
	# ----- Setup ----- #
	
	var channel = p.channel
	var mock_reference_registry = direct.script(ReferenceRegistry, "Reference")
	mock_reference_registry.method("add_reference")
	var story_audio_manager = StoryAudioManagerBuilder.new().default(direct) \
		.inject_reference_registry(mock_reference_registry.double()) \
		.build()
	add_child(story_audio_manager)
	
	# ----- Setup ----- #
	
	
	asserts.is_null(story_audio_manager.get_channel_controller(channel), "Then the channel controller does not exist before the call.")
	
	var channel_controller = story_audio_manager.add_new_channel(channel)
	asserts.was_called_with_arguments(mock_reference_registry, "add_reference", [channel], "Then the channel was added to the reference registry after the call.")
	
	asserts.is_not_null(story_audio_manager.get_channel_controller(channel), "Then the channel controller exists after the call.")
	asserts.is_true(FracUtils.is_type(channel_controller, "StoryAudioChannelController"), "Then the return value is a StoryAudioChannelController.")
	asserts.is_equal(channel_controller.story_audio_channel, channel, "Then the returned controller has the correct channel.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(story_audio_manager)
	FracUtils.try_free(channel_controller)
	
	# ----- Cleanup ----- #


func test_state_serialization():
	describe("When calling serialize_state() and deserialize_state()")
	
	# ----- Setup ----- #
	
	var fake_reference_registry = ReferenceRegistryFakes.TestGetAddReference.new()
	var serialization_manager = SerializationManagerBuilder.new().default(direct) \
		.inject_serializer(StoryAudioChannelSerializerBuilder.new().default(direct) \
			.inject_reference_registry(fake_reference_registry) \
			.build()) \
		.build()
	var story_audio_manager = StoryAudioManagerBuilder.new().default(direct) \
		.inject_reference_registry(fake_reference_registry) \
		.inject_serialization_manager(serialization_manager) \
		.build()
	
	add_child(story_audio_manager)
	add_child(serialization_manager)
	
	# Add the channels to give the story_audio_manager channels
	# and channel controllers.
	var channel_set = ChannelBuilder.new().full_5_set()	
	var channel_controllers: Array = []
	for channel in channel_set:
		channel_controllers.append(story_audio_manager.add_new_channel(channel))
	
	# ----- Setup ----- #
	
	
	var serialized_state = story_audio_manager.serialize_state()
	
	story_audio_manager.deserialize_state(serialized_state)
	
	asserts.is_true(FracUtils.equals(story_audio_manager.get_channels(), channel_set), "Then the channels were serialized and deserialized successfully.")
	asserts.is_true(FracUtils.equals(story_audio_manager.get_channel_controllers(), channel_controllers), "Then the channel controllers were serialized and deserialized successfully.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(story_audio_manager)
	FracUtils.try_free(serialization_manager)
	
	# ----- Cleanup ----- #


var test_audio_channel_creation_parameters: Array
func test_audio_channel_creation():
	parameters(test_audio_channel_creation_parameters)
	describe("When calling AudioChannel() with the variables of a preset channel")
	
	# ----- Setup ----- #
	
	var channel = p.channel
	var story_audio_manager = StoryAudioManagerBuilder.new().default(direct).build()
	
	# ----- Setup ----- #
	
	
	var channel_result = story_audio_manager.AudioChannel(channel.audio_bus, channel.volume_db, channel.pitch_scale, channel.queue_by_default, channel.is_skippable)
	
	asserts.is_true(FracUtils.equals(channel, channel_result), "Then the created channel == preset channel")
	asserts.is_true(FracUtils.equals(story_audio_manager.get_channels().front(), channel), "Then the created channel was added to the channels list.")
	asserts.is_true(FracUtils.is_type(story_audio_manager.get_channel_controller(channel_result), "StoryAudioChannelController"), "Then the created channel has a corresopnding controller.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(story_audio_manager)
	
	# ----- Cleanup ----- #


var test_audio_channel_creation_error_handling_parameters: Array
func test_audio_channel_creation_error_handling():
	parameters(test_audio_channel_creation_error_handling_parameters)
	describe("When calling AudioChannel() with invalid arguments")
	
	# ----- Setup ----- #
	
	var story_audio_manager = StoryAudioManagerBuilder.new().default(direct).build()
	
	# ----- Setup ----- #
	
	
	var channel_result = story_audio_manager.AudioChannel(p.audio_bus, p.volume_db, p.pitch_scale, p.queue_by_default, p.is_skippable)
	
	asserts.is_true(not SSUtils.is_success(channel_result), "Then it returns an error: %s." % str(channel_result))
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(story_audio_manager)
	
	# ----- Cleanup ----- #	
