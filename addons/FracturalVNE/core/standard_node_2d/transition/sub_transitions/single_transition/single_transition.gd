extends Node
# Base class for SingleTransitions


# ----- Typeable ----- #

func get_types() -> Array:
	return ["SingleTransition", "Transition"]

# ----- Typeable ----- #


signal transition_finished(skipped)

enum TransitionType {
	SHOW,
	HIDE
}

export(TransitionType) var transition_type: int

var is_transitioning: bool = false
var node: Node
var duration: float
var does_cleanup: bool = false


# Return false if the transition was stopped prematurely
func transition(node_: Node, duration_: float, does_cleanup_ = true):
	if not _setup_transition(node_, duration_, does_cleanup_):
		return

func cleanup():
	node.visible = transition_type == TransitionType.SHOW


func _setup_transition(node_: Node, duration_: float, does_cleanup_: bool):
	if is_transitioning:
		return false
	is_transitioning = true
	
	node = node_
	node.visible = true
	duration = duration_
	does_cleanup = does_cleanup_
	
	return true


func _on_transition_finished(skipped: bool) -> void:
	is_transitioning = false
	if does_cleanup:
		cleanup()
	emit_signal("transition_finished", skipped)
