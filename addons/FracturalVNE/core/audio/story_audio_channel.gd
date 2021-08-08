class_name FracVNE_StoryAudioChannel, "res://addons/FracturalVNE/assets/icons/audio_channel.svg"
extends Resource
# Stores information about an StoryAudioChannel.
# There are no plans for caching audio channels for now...


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryAudioChannel", "Serializable"]

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

export var audio_bus: String
export var volume_db: float
export var pitch_scale: float
export var queue_by_default: bool
# Is the audio in this channel skippable?
export var is_skippable: bool


func _init(audio_bus_: String = "Master", volume_db_: float = 0, pitch_scale_: float = 1, queue_by_default_: bool = false, is_skippable_: bool = false):
	audio_bus = audio_bus_
	volume_db = volume_db_
	pitch_scale = pitch_scale_
	queue_by_default = queue_by_default_
	is_skippable = is_skippable_


func instantiate_controller(story_director):
	var instance = _get_controller_prefab().instance()
	var init_result = instance.init(self, story_director)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return instance


func _get_controller_prefab():
	return preload("story_audio_channel.tscn")


# ----- Serialization ----- #

func serialize() -> Dictionary:
	return {
		"script_path": get_script().get_path(),
		"audio_bus": audio_bus,
		"volume_db": volume_db,
		"pitch_scale": pitch_scale,
		"queue_by_default": queue_by_default,
		"is_skippable": is_skippable,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.audio_bus = serialized_object["audio_bus"]
	instance.volume_db = serialized_object["volume_db"]
	instance.pitch_scale = serialized_object["pitch_scale"]
	instance.queue_by_default = serialized_object["queue_by_default"]
	instance.is_skippable = serialized_object["is_skippable"]
	return instance

# ----- Serialization ----- #
