extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# Extracts variables from a SingleTransition and places
# them into NodeVariables.


export var single_transition_path: NodePath
export var duration_var_path: NodePath
export var trans_node_var_path: NodePath

onready var single_transition = get_node(single_transition_path)
onready var duration_var = get_node(duration_var_path)
onready var trans_node_var = get_node(trans_node_var_path)


func run(args = []):
	duration_var.value = single_transition.duration
	trans_node_var.value = single_transition.node
	_finish(args)

# TODO NOW: FIX
