extends WAT.Test
# Tests the behaviour of StoryAudioChannel.


const FracUtils = FracVNE.Utils
const ChannelControllerBuilder = preload("res://tests/core/audio/story_audio_channel_controller.builder.gd")

const BUILT_CONTROLLER: int = 0
const BUILT_CHANNEL: int = 1
const BUILT_DIRECTOR: int = 2

const SOUND_SAMPLE = preload("res://tests/assets/test_sound.wav")
const Channel = FracVNE_StoryAudioChannel


func title():
	return "StoryAudioChannelController"


# ----- Tests ----- #

func test_not_skippable_play():
	describe("When not skippable and called play()")
	
	var builder = ChannelControllerBuilder.new() \
		.unskippable_channel() \
		.spy_story_director() \
		.build()
	
	var controller = builder.controller
	var spy_story_director = builder.story_director
	
	add_child(controller)
	controller.play(SOUND_SAMPLE)
	
	asserts.is_true(controller.audio_player.is_playing(), "Then, @time = 0, the audio player is playing.")
	asserts.is_equal(controller.audio_player.stream, SOUND_SAMPLE, "Then, @time = 0, the audio player is playing the correct sample.")
	
	# We cannot wait for 1/2 sound_sample length or greater since it seems like
	# you may sometimes hit a race condition where the audio player finishes early before the 
	# wait is finished. I guess SOUND_SAMPLE.get_length() is exactly an accurate representation
	# of the time it will take to play the sound.
	var halfway_delay: float = SOUND_SAMPLE.get_length() / 3.0
	yield(until_timeout(halfway_delay), YIELD)

	asserts.is_true(controller.audio_player.is_playing(), "Then, @time = 1/3 sample's length, the audio player is playing.")
	asserts.is_equal(controller.audio_player.stream, SOUND_SAMPLE, "Then, @time = 1/3 of sample's legnth, the audio player is playing the correct sample.")

	yield(until_signal(controller, "finished_playing", SOUND_SAMPLE.get_length() + 10), YIELD)
	
	asserts.is_false(controller.audio_player.is_playing(), "Then, @time > sample's length, the audio player stops playing.")
	asserts.is_null(controller.audio_player.stream, "Then, @time > sample's length, the audio player's stream is null.")
	
	asserts.is_equal(spy_story_director.add_step_action_call_count, 0, "Then no step actions were added.")
	asserts.is_equal(spy_story_director.remove_step_action_call_count, 0, "Then no step actions were removed.")
	
	controller.free()


func test_skippable_play():
	describe("When skippable and called play()")
	
	var builder = ChannelControllerBuilder.new() \
		.skippable_channel() \
		.spy_story_director() \
		.build()
	
	var controller = builder.controller
	var spy_story_director = builder.story_director
	
	add_child(controller)
	controller.play(SOUND_SAMPLE)
	
	asserts.is_equal(spy_story_director.add_step_action_call_count, 1, "Then a step action is added at the start.")
	
	yield(until_signal(controller, "finished_playing", SOUND_SAMPLE.get_length() + 10), YIELD)
	
	asserts.is_equal(spy_story_director.remove_step_action_call_count, 1, "Then the step action is removed once at the end.")
	
	controller.free()


func test_skippable_destructor():
	describe("When skippable and the controller is deleted while playing.")
	
	var builder = ChannelControllerBuilder.new() \
		.skippable_channel() \
		.spy_story_director() \
		.build()
	
	var controller = builder.controller
	var spy_story_director = builder.story_director
	
	add_child(controller)
	controller.play(SOUND_SAMPLE)
	controller.free()
	
	asserts.is_equal(spy_story_director.remove_step_action_call_count, 1, "Then the step action is removed.")


func test_skippable_play_then_skip():
	describe("When skippable, called play(), and skipped playing")
	
	var builder = ChannelControllerBuilder.new() \
		.skippable_channel() \
		.fake_story_director() \
		.build()
	
	var controller = builder.controller
	var fake_story_director = builder.story_director
	
	watch(controller, "finished_playing")
	
	add_child(controller)
	controller.play(SOUND_SAMPLE)
	
	fake_story_director._t__skip_all_step_actions()
	
	asserts.signal_was_emitted_x_times(controller, "finished_playing", 1, "Then the controller finished early.")

# ----- Tests ----- #
