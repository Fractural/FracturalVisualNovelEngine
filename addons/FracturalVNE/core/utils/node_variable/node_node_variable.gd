extends "node_variable.gd"
# Stores a Node.


export var path: NodePath

var value: Node


func _ready() -> void:
	if not path.is_empty():
		value = get_node(path)
