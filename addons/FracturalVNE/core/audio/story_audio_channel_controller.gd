extends Node
# Controls queueing and playing sounds for a StoryAudioChannel. 


const PlaySoundAction = preload("play_sound_action.gd")

export var audio_player_path: NodePath

var story_audio_channel
var sound_queue: Array = []
var story_director

var curr_play_sound_action

onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)


func init(story_audio_channel_ = null, story_director_ = null):
	story_audio_channel = story_audio_channel_
	story_director = story_director_
	
	audio_player = get_node(audio_player_path)
	
	audio_player.volume_db = story_audio_channel.volume_db
	audio_player.pitch_scale = story_audio_channel.pitch_scale
	audio_player.bus = story_audio_channel.audio_bus


func play(sound: AudioStream, queue: bool = false):
	if audio_player.is_playing():
		if queue:
			sound_queue.append(sound)
		else:
			_play_sound(sound)


func skip_current_sound():
	_audio_finished()


func _audio_finished():
	audio_player.stream = null
	if sound_queue.size() > 0:
		_play_sound(sound_queue.pop_front())


func _play_sound(sound: AudioStream):
	if curr_play_sound_action != null:
		story_director.remove_step_action(curr_play_sound_action)
	audio_player.stream = sound
	audio_player.play()
	story_director.add_step_action(PlaySoundAction.new(self))


func _notification(what):
	if story_director != null and curr_play_sound_action != null:
		story_director.remove_step_action(curr_play_sound_action)
