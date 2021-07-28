extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# Merges two SingleTransitions (one for show and another for hide)
# into a single transition that acts as a ReplaceTransition.
# When transition() is called this will play the hide transition
# for the old node and then the show transiton for the new node.
# This is useful for transitions like fading into and then out of black.


export var replace_transition_path: NodePath
export var transition_pair_path: NodePath

onready var replace_transition = get_node(replace_transition_path)
onready var transition_pair = get_node(transition_pair_path)

var args


func run(args_ = []):
	transition_pair.hide_transition.connect("transition_finished", self, "_on_hide_transition_finished")
	transition_pair.show_transition.connect("transition_finished", self, "_on_finish")
	args = args_
	transition_pair.hide_transition.transition(replace_transition.old_node, replace_transition.duration / 2)


func _on_hide_transition_finished():
	transition_pair.show_transition.transition(replace_transition.new_node, replace_transition.duration / 2)


func _on_finish():
	_finish(args)
