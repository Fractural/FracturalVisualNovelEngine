extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"


export var single_transition_path: NodePath
export var new_parent_path: NodePath

var original_parent: Node

onready var single_transition = get_node(single_transition_path)
onready var new_parent = get_node(new_parent_path)


func run(args = []):
	original_parent = single_transition.node.get_parent()
	FracVNE.Utils.reparent(single_transition.node, new_parent)
	_finish(args)
