extends Node
# Base class for ReplaceTransitions


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["ReplaceTransition", "Transition"]

# ----- Typeable ----- #


signal transition_finished()

signal _transition()

var is_transitioning: bool = false
var new_node: Node2D
var old_node: Node2D
var duration: float

func transition(new_node_: Node2D, old_node_: Node2D, duration_: float):
	if is_transitioning:
		return
	is_transitioning = true
	
	new_node = new_node_
	old_node = old_node_
	duration = duration_
	
	emit_signal("_transition")


func _on_transition_finished():
	is_transitioning = false
	emit_signal("transition_finished")
