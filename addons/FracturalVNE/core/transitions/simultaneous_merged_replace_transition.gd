extends Node
# Merges two SingleTransitions (one for show and another for hide)
# into a single transition that acts as a ReplaceTransition.
# When transition() is called this will play both the show and hide
# transitions simulmtaneously for the new and old nodes respectively.
# This is useful for transitions like crossfading between two nodes.


export var show_transition_dep_path: NodePath
export var hide_transition_dep_path: NodePath
export var replace_transition_path: NodePath

onready var show_transition_dep = get_node(show_transition_dep_path)
onready var hide_transition_dep = get_node(hide_transition_dep_path)
onready var replace_transition = get_node(replace_transition_path)


func _ready():
	show_transition_dep.dependency.connect("transition_finished", self, "_on_transition_finished")
	replace_transition.connect("_transition", self, "transition")


func transition():
	show_transition_dep.dependency.transition(replace_transition.new_node, replace_transition.duration)
	hide_transition_dep.dependency.transition(replace_transition.old_node, replace_transition.duration)


func _on_transition():
	pass # Replace with function body.
