extends Node
# Sends a second ready-like call named "_post_ready()" through all of 
# this node's children after its children receieved "_ready()".

# Allows children to execute code interacting with other scripts since on the 
# first ready call is often used to fetch node references with "get_node()".

# "ready()" is analogous to "Awake()" in Unity, whereas 
# "_post_ready()" is analogous to "Start()" in Unity.


export var scene_manager_path: NodePath

onready var scene_manager = get_node(scene_manager_path)


func _ready() -> void:
	scene_manager.connect("node_added", self, "_on_node_added")


func _on_node_added(node):
	if "_post_readied" in node and not node._post_readied:
		node._post_readied = true
		# Make _post_ready() calls after entire scene is readied
		node.call_deferred("_post_ready")
