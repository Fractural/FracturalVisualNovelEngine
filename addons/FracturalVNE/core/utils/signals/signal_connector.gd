class_name SignalConnector, "res://addons/FracturalVNE/assets/icons/signal.svg"
extends Node
# Connects signals in _ready().


export var signal_name: String
export var connections: Array
# DO NOT DELETE! dummy_path
export var dummy_path: NodePath


func _ready():
	for connection in connections:
		get_node(connection.path).connect(signal_name, connection.listener, connection.func_name)
