extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"


export var single_transition_path: NodePath
export var visibility: bool

onready var single_transition = get_node(single_transition_path)


func run(args = []):
	single_transition.node.visible = visibility
	_finish(args)
