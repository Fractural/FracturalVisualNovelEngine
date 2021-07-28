extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# Merges two SingleTransitions (one for show and another for hide)
# into a single transition that acts as a ReplaceTransition.
# When transition() is called this will play both the show and hide
# transitions simulmtaneously for the new and old nodes respectively.
# This is useful for transitions like crossfading between two nodes.


export var replace_transition_path: NodePath
export var transition_pair_path: NodePath

onready var replace_transition = get_node(replace_transition_path)
onready var transition_pair = get_node(transition_pair_path)

var args


func _ready():
	transition_pair.show_transition.connect("finished", self, "_on_finish")


func run(args_ = []):
	args = args_
	transition_pair.hide_transition.transition(replace_transition.old_node, replace_transition.duration)
	transition_pair.show_transition.transition(replace_transition.new_node, replace_transition.duration)


func _on_finish():
	_finish(args)
