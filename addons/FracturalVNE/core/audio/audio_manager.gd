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
		Param.new("volumb_db", 0),
		Param.new("pitch_scale", 1),
		Param.new("queue_by_default", false),
		]),
]


func configure_service(program_node):
	for channel in channel_controller_lookup.values():
		channel.queue_free()
	channel_controller_lookup = {}
	channels = []


func get_service_name():
	return "AudioManager"

# ----- StoryService ----- #


const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils

export var channels_holder_path: NodePath
export var story_director_path: NodePath
export var reference_registry_path: NodePath
export var serialization_manager_path: NodePath

var channels: Array = []
var channel_controller_lookup: Dictionary = {}

onready var channels_holder = get_node(channels_holder_path)
onready var story_director = get_node(story_director_path)
onready var reference_registry = get_node(reference_registry_path)
onready var serialization_manager = get_node(serialization_manager_path)


# ----- StoryScriptFunc ----- #

# -- StoryScriptErrorable -- #
func AudioChannel(audio_bus, volume_db, pitch_scale, queue_by_default):
	if not FracUtils.is_type(audio_bus, "String"):
		return SSUtils.error("Expected audio_bus to be a String.")
	if not FracUtils.is_type(volume_db, "float"):
		return SSUtils.error("Expected volume_db to be a float.")
	if not FracUtils.is_type(pitch_scale, "float"):
		return SSUtils.error("Expected pitch_scale to be a float.")
	if not FracUtils.is_type(queue_by_default, "bool"):
		return SSUtils.error("Expected queue_by_default to be a boolean.")
	
	var channel = add_new_channel(FracVNE_StoryAudioChannel.new(audio_bus, volume_db, pitch_scale, queue_by_default))
	if not SSUtils.is_success(channel):
		return channel
	
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
	return instance


func get_channel_controller(channel: FracVNE_StoryAudioChannel):
	return channel_controller_lookup.get(channel)


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
	for channel in channels:
		channel.queue_free()
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
