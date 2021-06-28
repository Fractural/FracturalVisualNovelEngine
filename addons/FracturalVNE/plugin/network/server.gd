extends "custom_networking.gd"

# Ran By The GUI when running in Editor
# Otherwise ignored (e.g Running GUI as a scene or exported scene)
# Since we're talking to localhost from localhost, we allow object decoding


var story_file_path: String = ""
var quit_to_scene_path: String = ""

var _server: NetworkedMultiplayerENet


func _ready() -> void:
	host()


func host() -> void:
	close()
	_server = NetworkedMultiplayerENet.new()
	var err: int = _server.create_server(ProjectSettings.get_setting("Fractural_VNE/Port"))
	_server.allow_object_decoding = true
	if err != OK:
		push_warning(err as String)
	custom_multiplayer.network_peer = _server
	custom_multiplayer.connect("network_peer_connected", self, "_on_peer_connected")


func close() -> void:
	if is_instance_valid(_server):
		_server.close_connection()
		_server = null


func _on_peer_connected(id: int) -> void:
	rpc_id(id, "run_strategy_received", story_file_path, quit_to_scene_path)
