extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Plays a sound on a channel


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("SoundStatement")
	return arr

# ----- Typeable ----- #


var channel
var sound


func _init(position_ = null, channel_ = null, sound_ = null).(position_):
	channel = channel_
	sound = sound_


func execute():
	var channel_result = SSUtils.evaluate_and_cast(channel, "StoryAudioChannel")
	if not is_success(channel_result):
		throw_error(stack_error(channel_result, 
			"Could not evaluate the channel for the sound statement."))
		return
	
	var sound_result = SSUtils.evaluate_and_cast(sound, "AudioStream")
	if not is_success(sound_result):
		throw_error(stack_error(sound_result,
			"Could not evaluate the sound for the sound statement."))
		return
	
	# ChannelController should never be zero since it is always intialized
	# (No caching has been implemented yet for channels since they are 
	# unlikely to hurt performance).
	var channel_controller = get_runtime_block().get_service("StoryAudioManager").get_channel_controller(channel_result)
	channel_controller.play(sound_result)
	
	_finish_execute()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "SOUND:" 
	
	string += "\n" + tabs_string + "{"
	
	string += "\n" + tabs_string + "\tCHANNEL:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + channel.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	
	if sound != null:
		string += "\n" + tabs_string + "\tSOUND:"
		string += "\n" + tabs_string + "\t{"
		string += "\n" + sound.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"

	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = channel.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if sound != null:
		result = sound.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["channel"] = channel.serialize()
	serialized_object["sound"] = sound.serialize()
	
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.channel = SerializationUtils.deserialize(serialized_object["channel"])
	instance.sound = SerializationUtils.deserialize(serialized_object["sound"])
	
	return instance

# ----- Serialization ----- #
