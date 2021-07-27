extends Node
# Merges two SingleTransitions (one for show and another for hide)
# into a single transition that acts as a ReplaceTransition.
# When transition() is called this will play the hide transition
# for the old node and then the show transiton for the new node.
# This is useful for transitions like fading into and then out of black.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("MergedReplaceTransition")
	return arr

# ----- Typeable ----- #


export var show_transition_path: NodePath
export var hide_transition_path: NodePath

onready var show_transition = get_node(show_transition_path)
onready var hide_transition = get_node(hide_transition_path)


func init(show_transition_, hide_transition_):
	show_transition_path = get_path_to(show_transition_)
	hide_transition_path = get_path_to(hide_transition_)
	
	show_transition = show_transition_
	hide_transition = hide_transition_
	
	hide_transition.connect("transition_finished", self, "_on_hide_transition_finished")
	show_transition.connect("transition_finished", self, "_on_transition_finished")


func _transition():
	hide_transition.transition(old_node, duration / 2)


func _on_hide_transition_finished():
	show_transition.transition(new_node, duration / 2)
