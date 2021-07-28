extends "node_variable.gd"
# Stores a Node.


export var path: NodePath

var value: Node


func _ready():
	if not path.is_empty():
		value = get_node(path)
