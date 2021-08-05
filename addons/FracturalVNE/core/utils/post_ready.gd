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
	scene_manager.connect("scene_readied", self, "_on_scene_readied")

func _on_scene_readied(readied_scene):
	# Make _post_ready() calls after entire scene is readied 
	readied_scene.propagate_call("_post_ready")
