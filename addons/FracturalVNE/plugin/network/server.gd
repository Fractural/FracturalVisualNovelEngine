extends "custom_networking.gd"
# Ran By The GUI when running in Editor
# Otherwise ignored (e.g Running GUI as a scene or exported scene)
# Since we're talking to localhost from localhost, we allow object decoding


const FracUtils = FracVNE.Utils

export var dep__persistent_data_path: NodePath

var _server: NetworkedMultiplayerENet

onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func _ready() -> void:
	host()


func host() -> void:
	close()
	_server = NetworkedMultiplayerENet.new()
	var err: int = _server.create_server(persistent_data.port)
	_server.allow_object_decoding = true
	if err != OK:
		push_warning(err as String)
	custom_multiplayer.network_peer = _server
	custom_multiplayer.connect("network_peer_connected", self, "_on_peer_connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_on_peer_disconnected")


func close() -> void:
	if is_instance_valid(_server):
		_server.close_connection()
		_server = null


func _on_peer_connected(id: int) -> void:
	pass


func _on_peer_disconnected(id: int) -> void:
	persistent_data.load_data_from_file()
