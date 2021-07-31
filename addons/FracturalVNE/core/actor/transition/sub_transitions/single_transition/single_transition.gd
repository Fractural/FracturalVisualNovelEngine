extends Node
# Base class for SingleTransitions


# ----- Typeable ----- #

func get_types() -> Array:
	return ["SingleTransition", "Transition"]

# ----- Typeable ----- #


signal transition_finished()

enum TransitionType {
	SHOW,
	HIDE
}

export(TransitionType) var transition_type: int

var is_transitioning: bool = false
var node: Node
var duration: float


# Return false if the transition was stopped prematurely
func transition(node_: Node, duration_: float):
	if is_transitioning:
		return false
	is_transitioning = true
	
	node = node_
	duration = duration_
	
	return true


func _on_transition_finished(skipped):
	is_transitioning = false
	node.visible = transition_type == TransitionType.SHOW
	emit_signal("transition_finished")
