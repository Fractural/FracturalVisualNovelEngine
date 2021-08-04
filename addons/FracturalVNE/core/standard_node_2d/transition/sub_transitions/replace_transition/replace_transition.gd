extends Node
# Base class for ReplaceTransitions


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ReplaceTransition", "Transition"]

# ----- Typeable ----- #


signal transition_finished(skipped)

var is_transitioning: bool = false
var new_node: Node
var old_node: Node
var duration: float


func transition(new_node_: Node, old_node_: Node, duration_: float):
	if not _setup_transition(new_node_, old_node_, duration_):
		return

func _setup_transition(new_node_: Node, old_node_: Node, duration_: float):
	if is_transitioning:
		return false
	is_transitioning = true
	
	new_node = new_node_
	old_node = old_node_
	duration = duration_
	
	new_node.visible = true
	old_node.visible = true
	
	return true


func _on_transition_finished(skipped):
	is_transitioning = false
	old_node.visible = false
	emit_signal("transition_finished", skipped)
