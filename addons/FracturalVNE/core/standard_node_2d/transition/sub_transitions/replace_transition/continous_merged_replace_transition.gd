extends "replace_transition.gd"
# Merges two SingleTransitions (one for show and another for hide)
# into a single transition that acts as a ReplaceTransition.
# When transition() is called this will play the hide transition
# for the old node and then the show transiton for the new node.
# This is useful for transitions like fading into and then out of black.


export var show_transition_path: NodePath
export var hide_transition_path: NodePath

var _hide_transition_finished: bool = false

onready var show_transition = get_node(show_transition_path)
onready var hide_transition = get_node(hide_transition_path)


func transition(new_node_: Node, old_node_: Node, duration_: float):
	if not _setup_transition(new_node_, old_node_, duration_):
		return
	
	# Hide new_node_ since old_node is currently transitioning
	# No need to worry about showing any nodes since SingleTransitions
	# automatically show the nodes while they are in use.
	new_node_.visible = false
	
	hide_transition.connect("transition_finished", self, "_on_hide_transition_finished")
	# If the show transition is finished, then the merged transition is also finished.
	# If the show transition is not finished (which can never happen in this case since it's
	# being used inside of a replace transition), then the merged transition is also not finished.
	# Therefore we do not need to make any custom modifications to the signal connection.
	show_transition.connect("transition_finished", self, "_on_transition_finished")
	hide_transition.transition(old_node, duration / 2)
	
	_hide_transition_finished = false


func _on_hide_transition_finished(skipped):
	show_transition.transition(new_node, duration / 2)
	_hide_transition_finished = true


func _on_transition_finished(skipped: bool) -> void:
	if skipped:
		if not _hide_transition_finished:
			# If we didn't finish the hide transition then we have to
			# skip both hide and show transition to reach the end.
			hide_transition.disconnect("transition_finished", self, "_on_hide_transition_finished")
			hide_transition._on_transition_finished(skipped)
		else:
			# If we finished the hide transition and are skipping, then
			# that means we have not finished the show transition.
			show_transition.disconnect("transition_finished", self, "_on_transition_finished")
			show_transition._on_transition_finished(skipped)
	# TODO NOW: Fix fade_to_black transition stack overflowing.
	._on_transition_finished(skipped)
