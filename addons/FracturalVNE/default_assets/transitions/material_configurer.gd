extends Node
# Configures a material for instance use.


export var node_holder_path: NodePath

onready var node_holder = get_node(node_holder_path)


func _ready():
	# duplicate(true) duplicates sub resources as well, which includes
	# the shader.
	node_holder.material = node_holder.material.duplicate(true)
