extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"


export var single_transition_path: NodePath
export var reparent_behaviour_path: NodePath

onready var single_transition = get_node(single_transition_path)
onready var reparent_behaviour = get_node(reparent_behaviour_path)


func run(args = []):
	FracVNE.Utils.reparent(single_transition.node, reparent_behaviour.original_parent)
	_finish(args)
