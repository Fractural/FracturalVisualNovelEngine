extends "replace_transition.gd"
# Merges two SingleTransitions (one for show and another for hide)
# into a single transition that acts as a ReplaceTransition.
# When transition() is called this will play both the show and hide
# transitions simulmtaneously for the new and old nodes respectively.
# This is useful for transitions like crossfading between two nodes.


export var show_transition_path: NodePath
export var hide_transition_path: NodePath

var _sub_transition_finished_counter: int = 0

onready var show_transition = get_node(show_transition_path)
onready var hide_transition = get_node(hide_transition_path)


func transition(new_node_: Node, old_node_: Node, duration_: float, is_skipping_loading_: bool = false):
	if not _setup_transition(new_node_, old_node_, duration_, is_skipping_loading_):
		return 
	_start_loading()


func finished_loading():
	hide_transition.connect("transition_finished", self, "_on_sub_transition_finished")
	show_transition.connect("transition_finished", self, "_on_sub_transition_finished")
	
	hide_transition.transition(old_node, duration)
	show_transition.transition(new_node, duration)
	
	_sub_transition_finished_counter = 0


func _on_sub_transition_finished(skipped):
	# Serves as a lock that waits until both hide and show transitions have
	# fired their transition_finished signals.
	_sub_transition_finished_counter += 1
	if _sub_transition_finished_counter >= 2:
		_on_transition_finished(false)


func _on_transition_finished(skipped: bool) -> void:
	if skipped:
		hide_transition._on_transition_finished(skipped)
		show_transition._on_transition_finished(skipped)
	._on_transition_finished(skipped)
