extends WAT.Test
# Tests the behaviour of StoryAudioChannel.


const FracUtils = FracVNE.Utils
const ChannelControllerBuilder = preload("res://tests/core/audio/story_audio_channel_controller.builder.gd")
const ChannelBuilder = preload("res://tests/core/audio/story_audio_channel.builder.gd")
const ChannelController = preload("res://addons/FracturalVNE/core/audio/story_audio_channel_controller.gd")
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")
const StoryDirectorFakes = preload("res://tests/core/story/director/story_director.fakes.gd")

const BUILT_CONTROLLER: int = 0
const BUILT_CHANNEL: int = 1
const BUILT_DIRECTOR: int = 2

const SOUND_SAMPLE = preload("res://tests/assets/test_sound.wav")
const Channel = FracVNE_StoryAudioChannel


func title():
	return "StoryAudioChannelController"


# ----- Tests ----- #

func test_playing_audio_for_unskippable_controller():
	describe("When not skippable and called play()")
	
	# ----- Setup ----- #
	
	var mock_story_director = direct.script(StoryDirector)
	mock_story_director.method("add_step_action")
	mock_story_director.method("remove_step_action")
	
	var controller = ChannelControllerBuilder.new().default(direct) \
		.inject_channel(ChannelBuilder.new().default(direct) \
			.inject_is_skippable(false) \
			.build()) \
		.inject_story_director(mock_story_director.double()) \
		.build()
	
	add_child(controller)
	
	# ----- Setup ----- #
	
	
	controller.play(SOUND_SAMPLE)
	
	asserts.is_equal(controller.get_current_sound(), SOUND_SAMPLE, "Then, @time = 0, the audio player is playing the correct sample.")
	
	# We cannot wait for 1/2 sound_sample length or greater since it seems like
	# you may sometimes hit a race condition where the audio player finishes early before the 
	# wait is finished. I guess SOUND_SAMPLE.get_length() is exactly an accurate representation
	# of the time it will take to play the sound.
	var halfway_delay: float = SOUND_SAMPLE.get_length() / 2.0
	yield(until_timeout(halfway_delay), YIELD)

	asserts.is_true(_is_audio_playing(), "Then, @time = 1/2 sample's length, the audio player is playing. Got volume: %s db." % [_current_master_volume()])
	asserts.is_equal(controller.get_current_sound(), SOUND_SAMPLE, "Then, @time = 1/2 of sample's legnth, the audio player is playing the correct sample.")

	yield(until_signal(controller, "finished_playing", SOUND_SAMPLE.get_length() + 3), YIELD)

	asserts.is_false(_is_audio_playing(), "Then, @time > sample's length, the audio player stops playing. Got volume: %s db." % [_current_master_volume()])
	asserts.is_null(controller.get_current_sound(), "Then, @time > sample's length, the audio player's stream is null.")
	
	asserts.is_equal(mock_story_director.call_count("add_step_action"), 0, "Then no step actions were added.")
	asserts.is_equal(mock_story_director.call_count("remove_step_action"), 0, "Then no step actions were removed.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(controller)
	
	# ----- Cleanup ----- #


func test_playing_audio_for_skippable_controller():
	describe("When skippable and called play()")
	
	# ----- Setup ----- #
	
	var mock_story_director = direct.script(StoryDirector)
	mock_story_director.method("add_step_action")
	mock_story_director.method("remove_step_action")
	
	var controller = ChannelControllerBuilder.new().default(direct) \
		.inject_channel(ChannelBuilder.new().default(direct) \
			.inject_is_skippable(true) \
			.build()) \
		.inject_story_director(mock_story_director.double()) \
		.build()
	
	add_child(controller)
	
	# ----- Setup ----- #
	
	
	controller.play(SOUND_SAMPLE)
	
	asserts.is_equal(mock_story_director.call_count("add_step_action"), 1, "Then a step action is added at the start.")
	yield(until_signal(controller, "finished_playing", SOUND_SAMPLE.get_length() + 10), YIELD)
	asserts.is_equal(mock_story_director.call_count("remove_step_action"), 1, "Then the step action is removed once at the end.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(controller)
	
	# ----- Cleanup ----- #


func test_destructor_cleanup_for_skippable_controller():
	describe("When skippable and the controller is deleted while playing.")
	
	# ----- Setup ----- #
	
	var mock_story_director = direct.script(StoryDirector)
	mock_story_director.method("add_step_action")
	mock_story_director.method("remove_step_action")

	var controller = ChannelControllerBuilder.new().default(direct) \
		.inject_channel(ChannelBuilder.new().default(direct) \
			.inject_is_skippable(true) \
			.build()) \
		.inject_story_director(mock_story_director.double()) \
		.build()
	
	add_child(controller)
	
	# ----- Setup ----- #
	
	
	controller.play(SOUND_SAMPLE)
	controller.free()
	
	asserts.is_equal(mock_story_director.call_count("remove_step_action"), 1, "Then the step action is removed.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(controller)
	
	# ----- Cleanup ----- #


func test_skipping_audio_for_skippable_controller():
	describe("When skippable, called play(), and skipped playing")
	
	# ----- Setup ----- #
	
	var fake_story_director = StoryDirectorFakes.TestSkip.new()
	var controller = ChannelControllerBuilder.new() \
		.inject_channel(ChannelBuilder.new().default(direct) \
			.inject_is_skippable(true) \
			.build()) \
		.inject_story_director(fake_story_director) \
		.build()
	
	watch(controller, "finished_playing")
	add_child(controller)
	
	# ----- Setup ----- #
	
	
	controller.play(SOUND_SAMPLE)
	
	fake_story_director.skip_all_step_actions()
	
	asserts.signal_was_emitted_x_times(controller, "finished_playing", 1, "Then the controller finished early.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(controller)
	
	# ----- Cleanup ----- #

# ----- Tests ----- #


func _is_audio_playing():
	# FUTURE REFACTOR: The db for silence is -INF in Godot 4.0 instead of -200.
	# Note that this does not support repeated, multi_threading tests, since
	# WAT will attempt to run the repeats in parallel, which leads to
	# all the threads playing sound on the same AudioServer (making it impossible
	# to distinguish which server is what).
	return _current_master_volume() > -190

func _current_master_volume():
	return AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Master"), 0);
