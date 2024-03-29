extends Node
# Handles the playing of sound on different StoryAudioChannels


# ----- StoryService ----- #

# Optional
const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

# Optional
var function_definitions = [
	FuncDef.new("AudioChannel", [
		Param.new("audio_bus", "Master"),
		Param.new("volume_db", 0),
		Param.new("pitch_scale", 1),
		Param.new("queue_by_default", false),
		Param.new("is_skippable", false),
		]),
]


func configure_service(program_node):
	for channel in channel_controller_lookup.values():
		channel.queue_free()
	channel_controller_lookup = {}
	channels = []


func get_service_name():
	return "StoryAudioManager"

# ----- StoryService ----- #


const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils

export var channels_holder_path: NodePath
export var story_director_path: NodePath
export var reference_registry_path: NodePath
export var serialization_manager_path: NodePath

var channels: Array = []
var channel_controller_lookup: Dictionary = {}

onready var channels_holder = FracUtils.get_valid_node_or_dep(self, channels_holder_path, channels_holder)
onready var story_director = FracUtils.get_valid_node_or_dep(self, story_director_path, story_director)
onready var reference_registry = FracUtils.get_valid_node_or_dep(self, reference_registry_path, reference_registry)
onready var serialization_manager = FracUtils.get_valid_node_or_dep(self, serialization_manager_path, serialization_manager)


# ----- StoryScriptFunc ----- #

# -- StoryScriptErrorable -- #
func AudioChannel(audio_bus, volume_db, pitch_scale, queue_by_default, is_skippable):
	if not FracUtils.is_type(audio_bus, "String"):
		return SSUtils.error("Expected audio_bus to be a String.")
	if not FracUtils.is_type(volume_db, "Number"):
		return SSUtils.error("Expected volume_db to be a number.")
	if not FracUtils.is_type(pitch_scale, "Number"):
		return SSUtils.error("Expected pitch_scale to be a number.")
	if not FracUtils.is_type(queue_by_default, "bool"):
		return SSUtils.error("Expected queue_by_default to be a boolean.")
	if not FracUtils.is_type(is_skippable, "bool"):
		return SSUtils.error("Expected is_skippable to be a boolean.")
	
	var channel = FracVNE_StoryAudioChannel.new(audio_bus, volume_db, pitch_scale, queue_by_default, is_skippable)
	var channel_instance = add_new_channel(channel)
	if not SSUtils.is_success(channel_instance):
		return channel_instance
	
	return channel

# ----- StoryScriptFunc ----- #


# -- StoryScriptErrrorable -- #
func add_new_channel(channel: FracVNE_StoryAudioChannel):
	if channels.has(channel):
		return
	
	channels.append(channel)
	var instance = channel.instantiate_controller(story_director)
	if not SSUtils.is_success(instance):
		return instance
	
	reference_registry.add_reference(channel)
	channel_controller_lookup[channel] = instance
	channels_holder.add_child(instance)
	
	return instance


func get_channel_controller(channel: FracVNE_StoryAudioChannel):
	return channel_controller_lookup.get(channel)


func get_channels():
	return channels


func get_channel_controllers():
	return channel_controller_lookup.values()

# TODO: Implement support for services to add defaults
#		Maybe even put this stuff in a dedicated defaults .tres
#		That can then be loaded by the player if they would like
#		to use defaults.


# ----- Serialization ----- #

func serialize_state() -> Dictionary:
	var serialized_channel_controller_lookup = {}
	for channel in channel_controller_lookup.keys():
		var channel_id = reference_registry.get_reference_id(channel)
		serialized_channel_controller_lookup[channel_id] = serialization_manager.serialize(channel_controller_lookup[channel])
	
	var channel_ids = []
	for channel in channels:
		channel_ids.append(reference_registry.get_reference_id(channel))
	
	return {
		"service_name": get_service_name(),
		"channel_controller_lookup": serialized_channel_controller_lookup,
		"channel_ids": channel_ids,
	}


func deserialize_state(serialized_state) -> void:
	for controller in channel_controller_lookup.values():
		controller.queue_free()
	channel_controller_lookup = {}
	channels = []
	
	# Default channels should be attached to channels, therefore there is
	# no need to reinitialize the defaul channels 
	
	for channel_id in serialized_state["channel_controller_lookup"].keys():
		var channel_controller = serialization_manager.deserialize(serialized_state["channel_controller_lookup"][channel_id])
		channel_controller_lookup[reference_registry.get_reference(int(channel_id))] = channel_controller
	
	for channel_id in serialized_state["channel_ids"]:
		channels.append(reference_registry.get_reference(channel_id))

# ----- Serialization ----- #
