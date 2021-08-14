extends "res://addons/FracturalVNE/core/standard_node_2d/transition/standard_node_2d_transitioner.gd"
# Allows for transitions to replace two nodes.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ReplaceableNodeTransitioner")
	return arr

# ----- Typeable ----- #


signal ready_for_loading()

export var old_node_holder_path: NodePath

onready var old_node_holder = get_node_or_null(old_node_holder_path)


# -- StoryScriptErrorable -- #
func replace(transition: FracVNE_StandardNode2DTransition = null, duration: float = 1, is_skippable: bool = true, is_skipping_loading: bool = true):
	_force_clear_current_transition()
	old_node_holder.visible = true
	node_holder.visible = true
	if transition != null:
		var result = _setup_new_transition(TransitionType.REPLACE, transition, is_skippable)
		if not SSUtils.is_success(result):
			return result
		curr_transition.connect("ready_for_loading", self, "_on_ready_for_loading")
		result = curr_transition.transition(node_holder, old_node_holder, duration, is_skipping_loading)
		if not SSUtils.is_success(result):
			return SSUtils.stack_error(result, "Could not play replace transition.")
	else:
		_on_transition_finished(false)


func _on_ready_for_loading():
	emit_signal("ready_for_loading")


func finished_loading():
	curr_transition.finished_loading()


func _on_transition_finished(skipped: bool) -> void:
	if curr_transition_type == TransitionType.REPLACE:
		old_node_holder.visible = false
	._on_transition_finished(skipped)
