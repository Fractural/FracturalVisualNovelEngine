extends "custom_networking.gd"


const IPAddress: String = "127.0.0.1"

export var story_runner_path: NodePath

var _client: NetworkedMultiplayerENet

onready var story_runner = get_node(story_runner_path)


func _ready() -> void:
	join()


func join() -> void:
	_client = NetworkedMultiplayerENet.new()
	var err: int = _client.create_client(IPAddress, ProjectSettings.get_setting("Fractural_VNE/Port"))
	_client.allow_object_decoding = true
	if err != OK:
		push_warning(err as String)
	custom_multiplayer.connect("connection_failed", self, "_on_connection_failed")
	custom_multiplayer.network_peer = _client


puppet func run_strategy_received(story_file_path: String, quit_to_scene_path: String) -> void:
	if not quit_to_scene_path == "":
		# If the quit scene path is not empty, then load in the quit scene.
		story_runner.run(story_file_path, load(quit_to_scene_path))
	else:
		# The quit scene is empty, therefore we haven no quit scene (null)
		story_runner.run(story_file_path)


func _on_failed() -> void:
	push_error("Connection failed")
