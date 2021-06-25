extends Node
# Sends a second ready-like call named "_post_ready()" through all of 
# this node's children after its children receieved "_ready()".

# Allows children to execute code interacting with other scripts since on the 
# first ready call is often used to fetch node references with "get_node()".

# "ready()" is analogous to "Awake()" in Unity, whereas 
# "_post_ready()" is analogous to "Start()" in Unity.


signal post_ready()


func _ready():
	propagate_call("_post_ready")
	emit_signal("post_ready")
