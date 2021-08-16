extends "custom_networking.gd"
# Ran By The GUI when running in Editor
# Otherwise ignored (e.g Running GUI as a scene or exported scene)
# Since we're talking to localhost from localhost, we allow object decoding
#
# TODO: Deprecated since we are using persistent data to store and transfer
#		information.

const FracUtils = FracVNE.Utils

export var persistent_data_path: NodePath

var story_file_path: String = ""
var quit_to_scene_path: String = ""

var _server: NetworkedMultiplayerENet

onready var persistent_data = FracUtils.get_valid_node_or_dep(self, persistent_data_path, persistent_data)


func _ready() -> void:
	host()


func host() -> void:
	print("Server starting host")
	close()
	_server = NetworkedMultiplayerENet.new()
	var err: int = _server.create_server(persistent_data.port)
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
	pass
	# We actually do not need any networking for now since we have PersistentData
	# to transfer information (data is always stored under the FracturalVNE folder).
