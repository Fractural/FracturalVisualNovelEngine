extends "custom_networking.gd"


const FracUtils = FracVNE.Utils
const IPAddress: String = "127.0.0.1"

export var story_runner_path: NodePath
export var dep__persistent_data_path: NodePath

var _client: NetworkedMultiplayerENet

onready var story_runner 	= FracUtils.get_valid_node_or_dep(self, story_runner_path, 	story_runner)
onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func _ready() -> void:
	join()


func join() -> void:
	_client = NetworkedMultiplayerENet.new()
	var err: int = _client.create_client(IPAddress, persistent_data.port)
	_client.allow_object_decoding = true
	if err != OK:
		push_warning(err as String)
	custom_multiplayer.connect("connection_failed", self, "_on_connection_failed")
	custom_multiplayer.network_peer = _client
	
	# Use the persistent data to launch
	story_runner.run(persistent_data.current_saved_story_path)
	OS.window_size = persistent_data.via_editor_window_size
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")


func _on_viewport_size_changed():
	persistent_data.via_editor_window_size = OS.window_size


# TODO: Deprecated due to the use of FracVNEPersistentData to transfer
#		information to the client.
#puppet func run_strategy_received(story_file_path: String, quit_to_scene_path: String) -> void:
#	if not quit_to_scene_path == "":
#		# If the quit scene path is not empty, then load in the quit scene.
#		story_runner.run(story_file_path, load(quit_to_scene_path))
#	else:
#		# The quit scene is empty, therefore we haven no quit scene (null)
#		story_runner.run(story_file_path)


func _on_failed() -> void:
	push_error("Connection failed")
