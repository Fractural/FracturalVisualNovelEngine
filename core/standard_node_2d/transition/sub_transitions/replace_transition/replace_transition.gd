extends Node
# Base class for ReplaceTransitions


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ReplaceTransition", "Transition"]

# ----- Typeable ----- #


# Emitted when the transition is ready for loading
# This is used by FullScreenTransitionManager to determine
# when the loading should start
signal ready_for_loading()
signal transition_finished(skipped)

var is_transitioning: bool = false
var is_skipping_loading: bool = false
var new_node: Node
var old_node: Node
var duration: float


func transition(new_node_: Node, old_node_: Node, duration_: float, is_skipping_loading_: bool = true):
	if not _setup_transition(new_node_, old_node_, duration_, is_skipping_loading_):
		return


func _start_loading():
	if is_skipping_loading:
		finished_loading()
	else:
		emit_signal("ready_for_loading")


func finished_loading():
	pass


func _setup_transition(new_node_: Node, old_node_: Node, duration_: float, is_skipping_loading_: bool):
	if is_transitioning:
		return false
	is_transitioning = true
	is_skipping_loading = is_skipping_loading_
	
	new_node = new_node_
	old_node = old_node_
	duration = duration_
	
	new_node.visible = true
	old_node.visible = true
	
	return true


func _on_transition_finished(skipped: bool) -> void:
	is_transitioning = false
	new_node.visible = true
	old_node.visible = false
	emit_signal("transition_finished", skipped)
