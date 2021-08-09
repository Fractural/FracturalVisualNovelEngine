extends Node
# Controls queueing and playing sounds for a StoryAudioChannel. 


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryAudioChannelController", "Equatable"]

# ----- Typeable ----- #


signal finished_playing()

const FracUtils = FracVNE.Utils
const PlaySoundAction = preload("play_sound_action.gd")

export var audio_player_path: NodePath

var story_audio_channel
var sound_queue: Array = []
var story_director

var curr_play_sound_action

onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)


func _ready():
	audio_player.connect("finished", self, "_audio_finished") 


func _notification(what):
	if what == NOTIFICATION_PREDELETE and story_director != null and curr_play_sound_action != null:
		story_director.remove_step_action(curr_play_sound_action)


func init(story_audio_channel_ = null, story_director_ = null):
	story_audio_channel = story_audio_channel_
	story_director = story_director_
	
	audio_player = get_node(audio_player_path)
	
	audio_player.volume_db = story_audio_channel.volume_db
	audio_player.pitch_scale = story_audio_channel.pitch_scale
	audio_player.bus = story_audio_channel.audio_bus


func play(sound: AudioStream, queue: bool = false):
	# By default sounds are not skippable.
	if audio_player.is_playing() and queue:
		sound_queue.append(sound)
	else:
		_play_sound(sound)


func get_current_sound():
	return audio_player.stream


func skip_current_sound():
	_audio_finished()


func _audio_finished():
	audio_player.stream = null
	_cleanup_step_action()
	emit_signal("finished_playing")
	if sound_queue.size() > 0:
		_play_sound(sound_queue.pop_front())


func _play_sound(sound: AudioStream):
	_cleanup_step_action()
	if story_audio_channel.is_skippable:
		# We only want to add a step action if the StoryChannel is skippable.
		curr_play_sound_action = PlaySoundAction.new(self)
		story_director.add_step_action(curr_play_sound_action)
	audio_player.stream = sound
	audio_player.play()


func _cleanup_step_action():
	if curr_play_sound_action != null:
		story_director.remove_step_action(curr_play_sound_action)
		curr_play_sound_action = null


# ----- Serialization ----- #

# story_audio_channel_controller_serializer.gd

# ----- Serialization ----- #


# ----- Equality ----- #

func equals(object):
	if not FracUtils.is_types(object, get_types()):
		return false
	return (FracUtils.equals(object.audio_player.stream, audio_player.stream) 
		and FracUtils.equals(object.sound_queue, sound_queue)
		and FracUtils.equals(object.story_audio_channel, story_audio_channel))

# ----- Equality ----- #
