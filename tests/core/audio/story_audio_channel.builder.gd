extends Reference
# Builds a StoryAudioChannel for testing.


const Channel = FracVNE_StoryAudioChannel


var audio_bus: String = "Master"
var volume_db: float = 1
var pitch_scale: float = 1
var queue_by_default: bool = false
var is_skippable: bool = false

var channel


func build():
	channel = Channel.new(audio_bus, volume_db, pitch_scale, queue_by_default, is_skippable)
	return channel


func inject_audio_bus(audio_bus_: String):
	audio_bus = audio_bus_
	return self


func inject_volume_db(volume_db_: float):
	volume_db = volume_db_
	return self


func inject_pitch_scale(pitch_scale_: float):
	pitch_scale = pitch_scale_
	return self


func inject_queue_by_default(queue_by_default_: bool):
	queue_by_default = queue_by_default_
	return self


func inject_is_skippable(is_skippable_: bool):
	is_skippable = is_skippable_
	return self


func default(_direct):
	audio_bus = "Master"
	volume_db = 1
	pitch_scale = 1
	queue_by_default = false
	is_skippable = false
	return self


func full_5_set():
	 return [get_script().new() \
	.inject_audio_bus("Ambience") \
	.inject_volume_db(2.34) \
	.inject_pitch_scale(0.24) \
	.inject_queue_by_default(true) \
	.inject_is_skippable(false) \
	.build(),
	get_script().new() \
	.inject_audio_bus("") \
	.inject_volume_db(10) \
	.inject_pitch_scale(0.5) \
	.inject_queue_by_default(false) \
	.inject_is_skippable(false) \
	.build(),
	get_script().new() \
	.inject_audio_bus("Sound Effects") \
	.inject_volume_db(-30) \
	.inject_pitch_scale(10) \
	.inject_queue_by_default(true) \
	.inject_is_skippable(true) \
	.build(),
	get_script().new() \
	.inject_audio_bus("Super Long Long Long Long Long Long Long Audio Bus") \
	.inject_volume_db(-2.54) \
	.inject_pitch_scale(0.24) \
	.inject_queue_by_default(false) \
	.inject_is_skippable(true) \
	.build(),
	get_script().new() \
	.inject_audio_bus("An Audio Bus Name") \
	.inject_volume_db(30) \
	.inject_pitch_scale(12) \
	.inject_queue_by_default(false) \
	.inject_is_skippable(false) \
	.build(),
	]
	
	
