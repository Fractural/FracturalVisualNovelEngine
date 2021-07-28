extends Node
# Base class for SingleTransitions


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["SingleTransition", "Transition"]

# ----- Typeable ----- #


signal transition_finished()

signal _transition()

var is_transitioning: bool = false
var node: Node2D
var duration: float


# Return false if the transition was stopped prematurely
func transition(node_: Node2D, duration_: float):
	if is_transitioning:
		return false
	is_transitioning = true
	
	node = node_
	duration = duration_
	
	emit_signal("_transition")


func _on_transition_finished():
	is_transitioning = false
	emit_signal("transition_finished")
