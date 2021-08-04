extends Node
# Configures a tint material to make it ready for instance use.


export var node_holder_path: NodePath
export var tint_color: Color

onready var node_holder = get_node(node_holder_path)


func _ready():
	# duplicate(true) duplicates sub resources as well, which includes
	# the shader.
	node_holder.material = node_holder.material.duplicate(true)
	node_holder.material.set_shader_param("tint_color", tint_color)
