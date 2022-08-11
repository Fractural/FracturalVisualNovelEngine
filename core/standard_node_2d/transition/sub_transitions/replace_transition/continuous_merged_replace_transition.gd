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


func transition(new_node_: Node, old_node_: Node, duration_: float, is_skipping_loading_: bool = true):
	if not _setup_transition(new_node_, old_node_, duration_, is_skipping_loading_):
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
	
	# false overrides the cleanup done by hide automatically
	# after a transition is done. This lets the final part of the hide
	# transition remain on screen while we are loading.
	# 
	# ie. in a fade to black transition, we want to leave the
	# black screen, created by the hide transition, on during
	# the loading
	hide_transition.transition(old_node, duration / 2, false)
	
	_hide_transition_finished = false


func finished_loading():
	hide_transition.cleanup()
	show_transition.transition(new_node, duration / 2)


func _on_hide_transition_finished(skipped):
	_hide_transition_finished = true
	_start_loading()


func _on_transition_finished(skipped: bool) -> void:
	if skipped:
		if not _hide_transition_finished:
			# If we didn't finish the hide transition then we have to
			# skip both hide and show transition to reach the end.
			hide_transition.disconnect("transition_finished", self, "_on_hide_transition_finished")
			hide_transition._on_transition_finished(true)
			hide_transition.cleanup()
		else:
			# If we finished the hide transition and are skipping, then
			# that means we have not finished the show transition.
			show_transition.disconnect("transition_finished", self, "_on_transition_finished")
			show_transition._on_transition_finished(true)
	._on_transition_finished(skipped)
